// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract ERC20 is IERC20{
    // 用 override 修饰 public 变量会重写继承自父合约的与变量同名的getter函数
    // 比如IERC20中的balanceOf() allowance() totalSupply()函数。
    mapping(address => uint256) public override balanceOf;

    mapping(address => mapping(address => uint256)) public override allowance;

    // 代币总供给量
    uint256 public override totalSupply;
    
    // 名称
    string public name;

    // 代号
    string public symbol;

    // 小数位数
    uint public decimals = 18;

    // @dev 在合约部署的时候实现合约名称和符号
    constructor(string memory  name_ ,string memory symbol_){
        name = name_;
        symbol = symbol_;
    }
    // @dev 代币转账逻辑
    // @param recipient 接收方
    function transfer(address recipient, uint256 amount) external override returns (bool){
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender,recipient,amount);
        return true;
    }

    // @dev 代币授权逻辑
    // @note spender 被委托方
    function approve(address spender, uint256 amount) external override returns (bool){
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender,spender,amount);

        return true;
    }
    
    // @dev 实现`transferFrom`函数，代币授权转账逻辑
    // @param sender 授权方
    // @note msg.sender 被委托方
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external override returns (bool){
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender,recipient,amount);
        return true;
    }

    // @dev 铸造代币，从 `0` 地址转账给 调用者地址
    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    // @dev 销毁代币，从 调用者地址 转账给  `0` 地址
    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }    
}