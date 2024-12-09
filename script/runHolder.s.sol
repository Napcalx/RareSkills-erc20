// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Script, console} from "forge-std/Script.sol";
import {TokenHolder} from "../src/Holder.sol"; // Adjust the path if necessary

contract DeployTokenHolder is Script {
    address tokenAddress = 0x5FbDB2315678afecb367f032d93F642f64180aa3; // Set the deployed token address here

    function run() public {
        vm.startBroadcast();

        // Deploy the TokenHolder contract
        TokenHolder tokenHolder = new TokenHolder(tokenAddress);

        console.log("TokenHolder deployed at:", address(tokenHolder));

        vm.stopBroadcast();
    }
}
