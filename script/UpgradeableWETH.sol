// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import {WETH_v1} from "../src/WETH_v1.sol";
import {WETH_v2} from "../src/WETH_v2.sol";

contract UpdWETHScript is Script {
    function deploy() external returns (address proxyAddress, address implementationAddress) {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address upgrader = vm.addr(privateKey);

        vm.startBroadcast(privateKey);

        WETH_v1 implementation = new WETH_v1();

        bytes memory initData = abi.encodeCall(WETH_v1.initialize, (upgrader));

        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), initData);

        vm.stopBroadcast();

        proxyAddress = address(proxy);
        implementationAddress = address(implementation);
        WETH_v1 weth = WETH_v1(payable(proxyAddress));

        console2.log("Impl:", implementationAddress);
        console2.log("Proxy:", proxyAddress);
        console2.log("Version:", weth.version());
    }

    function upgrade() external returns (address newImplementationAddress) {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address proxyAddress = vm.envAddress("PROXY_ADDRESS");

        vm.startBroadcast(privateKey);

        WETH_v2 newImpl = new WETH_v2();

        bytes memory initData = abi.encodeCall(WETH_v2.initializeV2, ());

        WETH_v2(payable(proxyAddress)).upgradeToAndCall(address(newImpl), initData);

        vm.stopBroadcast();

        WETH_v2 weth = WETH_v2(payable(proxyAddress));
        newImplementationAddress = address(newImpl);
        console2.log("Impl:", newImplementationAddress);
        console2.log("Proxy:", proxyAddress);
        console2.log("Version:", weth.version());
    }
}