// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {WETH_v1} from "../src/WETH_v1.sol";

contract WETHTest is Test {
    WETH_v1 weth;
    address user = address(0xA11CE);

    function setUp() public {
        weth = new WETH_v1();
        vm.deal(user, 10 ether);
    }

    function test_Mint() public {
        vm.prank(user);
        weth.mint{value: 1 ether}();

        assertEq(weth.balanceOf(user), 1 ether); // check WETH balance
        assertEq(address(weth).balance, 1 ether); // check reserve ETH
    }

    function test_MintOnRecieve() public {
        vm.prank(user);
        (bool ok,) = address(weth).call{value: 1 ether}("");
        assertTrue(ok);

        assertEq(weth.balanceOf(user), 1 ether); // check WETH balance
        assertEq(address(weth).balance, 1 ether); // check reserve ETH
    }

    function test_Burn() public {
        vm.prank(user);
        weth.mint{value: 2 ether}();

        uint256 userBalanceBefore = user.balance;

        vm.prank(user);
        weth.burn(1 ether);

        assertEq(weth.balanceOf(user), 1_000_000_000_000_000_000);
        assertEq(address(weth).balance, 1 ether);
        assertEq(user.balance, userBalanceBefore + 1 ether);
    }
}