// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.33;

import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IERC3156FlashLender} from "@openzeppelin/contracts/interfaces/IERC3156FlashLender.sol";
import {IERC3156FlashBorrower} from "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";

import {WETH_v1} from "../src/WETH_v1.sol";

contract WETH_v2 is WETH_v1, ReentrancyGuard, IERC3156FlashLender {

    function initializeV2() external reinitializer(2) {}

    function version() external pure override returns (string memory) {
        return "version 2";
    }
    
    bytes32 private constant CALLBACK_SUCCESS = keccak256("ERC3156FlashLender.onFlashLoan");
    
    uint256 public flashFeePercent = 9; // 9%


    // Flash Loans

    function maxFlashLoan(address token) external view override returns (uint256) {
        return token == address(this) ? totalSupply() : 0;
    }

    function flashFee(address token, uint256 amount) public view override returns (uint256) {
        require(token == address(this), "Unsupported token");
        return (amount * flashFeePercent) / 10000; // eips ???
    }

    function flashLoan(
        IERC3156FlashBorrower receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) external override nonReentrant returns (bool) {
        require(token == address(this), "Unsupported token");
        uint256 fee = flashFee(token, amount);

        _mint(address(receiver), amount);

        require(
            receiver.onFlashLoan(msg.sender, token, amount, fee, data) == CALLBACK_SUCCESS,
            "FlashLoan: Callback failed"
        );

        uint256 totalRepayment = amount + fee;
        require(allowance(address(receiver), address(this)) >= totalRepayment, "FlashLoan: Insufficient allowance");
        
        _spendAllowance(address(receiver), address(this), totalRepayment);
        _burn(address(receiver), totalRepayment);

        return true;
    }
}