// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {TokenHolder} from "../src/Holder.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    // Expose mint function for testing
    function mint(address account, uint256 amount) external {
        _mint(account, amount);
    }
}

contract TestTokenHolder is Test {
    TokenHolder tokenHolder;
    MockERC20 token;

    address user1 = address(0x123);
    uint256 initialSupply = 1000 * 10 ** 18;

    function setUp() public {
        // Deploy a new mock ERC20 token contract with initial supply
        token = new MockERC20("Mock Token", "MTK");

        // Mint tokens to the test contract itself
        token.mint(address(this), initialSupply);

        // Deploy the TokenHolder contract
        tokenHolder = new TokenHolder(address(token));
    }

    function testDeposit() public {
        uint256 depositAmount = 100 * 10 ** 18;

        // Mint tokens to user1 and approve the TokenHolder contract
        token.mint(user1, depositAmount);
        vm.startPrank(user1);
        token.approve(address(tokenHolder), depositAmount);

        // Deposit tokens into the TokenHolder contract
        tokenHolder.deposit(token, depositAmount);

        // Check the deposits of the user
        uint256 depositBalance = tokenHolder.checkDeposits(user1);
        assertEq(
            depositBalance,
            depositAmount,
            "Deposit balance should match the deposited amount."
        );

        // Check that the user's balance is reduced by the deposit amount
        uint256 userBalance = token.balanceOf(user1);
        assertEq(
            userBalance,
            0,
            "User balance should be reduced by the deposit amount."
        );

        // Check that the contract's balance is increased by the deposit amount
        uint256 contractBalance = token.balanceOf(address(tokenHolder));
        assertEq(
            contractBalance,
            depositAmount,
            "Contract balance should be equal to the deposit amount."
        );
    }

    function testDepositFailsOnZeroAmount() public {
        uint256 depositAmount = 0;

        // Try depositing zero tokens (should fail)
        vm.startPrank(user1);
        token.mint(user1, depositAmount); // Mint zero tokens for the user
        token.approve(address(tokenHolder), depositAmount); // User approves the TokenHolder contract

        vm.expectRevert("amount must be greater than 0");
        tokenHolder.deposit(token, depositAmount);
    }

    // function testDepositFailsInsufficientBalance() public {
    //     // Mint tokens to the user
    //     token.mint(user1, 250 * 10 ** 18);

    //     // User approves TokenHolder to spend a certain amount (less than the deposit)
    //     vm.prank(user1);
    //     token.approve(address(tokenHolder), 500 * 10 ** 18); // Set approval to a value greater than the deposit amount

    //     // Now, try to deposit more than the allowance, expecting the "ERC20: transfer amount exceeds allowance" error
    //     vm.expectRevert("ERC20: transfer amount exceeds allowance");
    //     vm.prank(user1);
    //     tokenHolder.deposit(token, 500 * 10 ** 18); // Deposit amount exceeds the approved allowance
    // }
}
