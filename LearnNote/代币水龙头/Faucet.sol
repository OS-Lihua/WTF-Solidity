// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.0;

import "contracts/IERC20.sol";

contract Faucet{
    // event 
    event SendToken(address indexed  Receiver, uint256 indexed Amount);

    // 每天领取的代币术
    uint256 public amountAllow = 100;
    // 代币地址
    address public tokenContract;
    // 请求过代币的地址
    mapping (address => bool) public requestAddress; 
    // 构造
    constructor (address _tokenContract){
        tokenContract = _tokenContract;
    }

    function requestTokens() external {
        // 检查是否领取过
        require(requestAddress[msg.sender] == false, "Can't Request Multiple Times!");
        // 合约对象
        IERC20 token = IERC20(tokenContract);
        require(token.balanceOf(address(this)) >= amountAllow,"Faucet Empty!");
        // 转账
        token.transfer(msg.sender,amountAllow);
        // 记录
        requestAddress[msg.sender] = true;
        // 发送事件给前端
        emit SendToken(msg.sender, amountAllow);
    }
}