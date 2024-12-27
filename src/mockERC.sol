//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {IERC20} from "forge-std/interfaces/IERC20.sol";

contract MockERC is IERC20 {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 private _totalSupply;

    // Implement the required functions

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function allowance(
        address owner,
        address spender
    ) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        require(_balances[msg.sender] >= amount, "Insufficient balance");
        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
        return true;
    }

    function approve(
        address spender,
        uint256 amount
    ) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        require(_balances[sender] >= amount, "Insufficient balance");
        require(
            _allowances[sender][msg.sender] >= amount,
            "Allowance exceeded"
        );
        _balances[sender] -= amount;
        _balances[recipient] += amount;
        _allowances[sender][msg.sender] -= amount;
        return true;
    }

    // You may also add a mint function for testing purposes
    function mint(address account, uint256 amount) public {
        _balances[account] += amount;
        _totalSupply += amount;
    }

    function name() external view override returns (string memory) {}

    function symbol() external view override returns (string memory) {}

    function decimals() external view override returns (uint8) {}
}
