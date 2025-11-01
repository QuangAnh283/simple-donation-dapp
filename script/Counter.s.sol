// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Counter.sol";

contract CounterScript is Script {
    function run() external {
        vm.startBroadcast();
        new Counter();
        vm.stopBroadcast();
    }
}
