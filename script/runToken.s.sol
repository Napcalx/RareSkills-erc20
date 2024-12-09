// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {ScriptBase, console} from "forge-std/Script.sol";
import {Token} from "../src/Token.sol"; // Adjust the import path to where your Token contract is located

contract DeployToken is ScriptBase {
    uint256 public constant initialSupply = 1000000 * 10 ** 8; // Example initial supply (1 million tokens with 8 decimals)

    function run() public {
        // Deploy the Token contract
        vm.startBroadcast(); // Begin broadcasting to the network (simulate transaction execution)
        Token token = new Token(initialSupply); // Deploy with initial supply
        vm.stopBroadcast(); // Stop broadcasting
        console.log("Token deployed at:", address(token)); // Log the token address
    }
}
