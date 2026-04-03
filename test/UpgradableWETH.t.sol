// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.33;

import {Test, console2} from "forge-std/Test.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import {WETH_v1} from "../src/WETH_v1.sol";
import {WETH_v2} from "../src/WETH_v2.sol";

contract WETHUUPSTest is Test {
    WETH_v1 internal implementationV1;
    WETH_v2 internal implementationV2;

    address payable internal proxyAddress;
    address internal upgrader = address(0x1234);
    address internal notUpgrader = address(0x12345);

    function setUp() external {
        implementationV1 = new WETH_v1();

        bytes memory initData = abi.encodeCall(WETH_v1.initialize, (upgrader));

        ERC1967Proxy proxy = new ERC1967Proxy(address(implementationV1), initData);
        proxyAddress = payable(address(proxy));
    }

    function test_DeployV1State() external {
        WETH_v1 weth = WETH_v1(proxyAddress);
        assertEq(weth.version(), "version 1");
        assertEq(weth.upgrader(), upgrader);
    }

    function test_UpgradeToV2_V2State() external {
        WETH_v1 weth_v1 = WETH_v1(proxyAddress);
        implementationV2 = new WETH_v2();

        bytes memory initData = abi.encodeCall(WETH_v2.initializeV2, ());

        vm.prank(upgrader);
        weth_v1.upgradeToAndCall(address(implementationV2), initData);

        WETH_v2 weth = WETH_v2(proxyAddress);
        assertEq(weth.version(), "version 2");
        assertEq(weth.upgrader(), upgrader);
    }

    function test_CheckWhenReinitilizeTwice() external {
        WETH_v1 weth_v1 = WETH_v1(proxyAddress);
        implementationV2 = new WETH_v2();

        bytes memory initData = abi.encodeCall(WETH_v2.initializeV2, ());

        vm.prank(upgrader);
        weth_v1.upgradeToAndCall(address(implementationV2), initData);

        WETH_v2 weth = WETH_v2(proxyAddress);

        vm.expectRevert();
        weth.initializeV2();
    }
}