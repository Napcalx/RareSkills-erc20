// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "forge-std/Test.sol";
import "../src/Token.sol";

contract TokenTest is Test {
    Token token;
    address owner;
    address addr1;
    address addr2;

    function setUp() public {
        token = new Token(10 ether);

        owner = address(this);
        addr1 = address(0x123);
        addr2 = address(0x456);

        token.transfer(owner, 10 ether);
    }

    function testName() public {
        assertEq(token.name(), "Skills");
    }

    function testSymbol() public {
        assertEq(token.symbol(), "SKL");
    }

    function testDecimals() public {
        assertEq(token.decimals(), 8);
    }

    function testTotalSupply() public {
        assertEq(token.totalSupply(), 10 ether);
    }

    function testBalanceOf() public {
        assertEq(token.balanceOf(owner), 10 ether);
    }

    function testTransfer() public {
        token.transfer(addr1, 5 ether);
        assertEq(token.balanceOf(addr1), 5 ether);
        assertEq(token.balanceOf(owner), 5 ether);
    }

    function testTransferToZeroAddress() public {
        vm.expectRevert("cannot send to Zero address");
        token.transfer(address(0), 1 ether);
    }

    function testTransferInsufficientBalance() public {
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        token.transfer(addr1, 20 ether);
    }

    function testApprove() public {
        token.approve(addr1, 5 ether);
        assertEq(token.allowance(owner, addr1), 5 ether);
    }

    function testTransferFrom() public {
        token.approve(addr1, 5 ether);
        vm.prank(addr1);
        token.transferFrom(owner, addr2, 5 ether);

        assertEq(token.balanceOf(addr2), 5 ether);
        assertEq(token.balanceOf(owner), 5 ether);
    }

    function testTransferFromExceedsAllowance() public {
        token.approve(addr1, 5 ether);
        vm.expectRevert("ERC20: transfer amount exceeds allowance");
        token.transferFrom(owner, addr2, 10 ether);
    }

    function testTransferFromExceedsBalance() public {
        token.approve(addr1, 5 ether);
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        token.transferFrom(owner, addr2, 15 ether);
    }

    function testAllowance() public {
        token.approve(addr1, 10 ether);
        assertEq(token.allowance(owner, addr1), 10 ether);
    }
}
