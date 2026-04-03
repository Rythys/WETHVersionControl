// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.33;

import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";


contract WETH_v1 is Initializable, ERC20Upgradeable, UUPSUpgradeable {
    error ZeroAmount();
    error ETHTransferFailed();

    event Mint(address indexed account, uint256 amount);
    event Burn(address indexed account, uint256 amount);
    
    address public upgrader;

    constructor() {
        _disableInitializers();
    }

    function initialize(address initialUpgrader) public initializer {
        __ERC20_init("Wrapped ETH", "WETH");
        upgrader = initialUpgrader;
    }

    function version() external pure virtual returns (string memory) {
        return "version 1";
    }

    function _authorizeUpgrade(address) internal view override {
        require(msg.sender == upgrader, "Not authorized");
    }

    function mint() external payable {
        if (msg.value == 0) revert ZeroAmount();

        _mint(msg.sender, msg.value);
        emit Mint(msg.sender, msg.value);
    }

    function burn(uint256 amount) external {
        if (amount == 0) revert ZeroAmount();

        _burn(msg.sender, amount);
        (bool ok,) = payable(msg.sender).call{value: amount}("");
        if (!ok) revert ETHTransferFailed();

        emit Burn(msg.sender, amount);
    }

    function getReserve(address account) external view returns (uint256) {
        return balanceOf(account);
    }

    receive() external payable {
        if (msg.value == 0) revert ZeroAmount();

        _mint(msg.sender, msg.value);
        emit Mint(msg.sender, msg.value);
    }
}