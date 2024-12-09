// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenHolder {
    using SafeERC20 for IERC20;
    address public Token;

    mapping(address => uint256) private s_deposits;
    address owner;

    constructor(address _token) {
        Token = _token;
        owner = msg.sender;
    }

    function deposit(IERC20 _token, uint256 amount) external {
        require(amount > 0, "amount must be greater than 0");
        _token.safeTransferFrom(msg.sender, address(this), amount);

        s_deposits[msg.sender] += amount;
    }

    function checkDeposits(address user) public view returns (uint256) {
        return s_deposits[user];
    }
}
