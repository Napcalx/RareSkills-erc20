// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Token {
    mapping(address => uint) private s_balance;
    mapping(address => mapping(address => uint256)) private s_allowance;
    uint256 private s_totalSupply;

    event Transfer(
        address indexed sender,
        address indexed receiver,
        uint256 amount
    );

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    constructor(uint256 initialSupply) {
        s_totalSupply = initialSupply;
        s_balance[msg.sender] = s_totalSupply;
    }

    function name() public view returns (string memory) {
        return "Skills";
    }

    function symbol() public view returns (string memory) {
        return "SKL";
    }

    function decimals() public view returns (uint8) {
        return 8;
    }

    function totalSupply() public view returns (uint256) {
        return s_totalSupply;
    }

    function balanceOf(address user) public view returns (uint256 balance) {
        return s_balance[user];
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        require(
            value <= s_balance[msg.sender],
            "ERC20: transfer amount exceeds balance"
        );
        require(to != address(0), "cannot send to Zero address");
        s_balance[msg.sender] -= value;
        s_balance[to] += value;

        emit Transfer(msg.sender, to, value);
        return success;
    }

    function approve(
        address spender,
        uint256 amount
    ) public returns (bool success) {
        require(spender != address(0));
        require(amount <= s_balance[msg.sender]);
        s_allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return success;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public returns (bool success) {
        require(
            value <= s_balance[from],
            "ERC20: transfer amount exceeds balance"
        );
        require(
            value <= s_allowance[from][msg.sender],
            "ERC20: transfer amount exceeds allowance"
        );

        s_balance[from] -= value;
        s_balance[to] += value;
        s_allowance[from][msg.sender] -= value;

        emit Transfer(from, to, value);
        return success;
    }

    function allowance(
        address _owner,
        address _spender
    ) public returns (uint256 remaining) {
        return s_allowance[_owner][_spender];
    }

    function getBalance(address user) public view returns (uint256) {
        return s_balance[user];
    }
}
