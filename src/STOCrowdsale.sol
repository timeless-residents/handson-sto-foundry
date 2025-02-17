// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./SecurityToken.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract STOCrowdsale is ReentrancyGuard, Ownable {
    SecurityToken public token;
    uint256 public rate;
    uint256 public minInvestment;
    uint256 public maxInvestment;
    uint256 public endTime;

    mapping(address => uint256) public investments;

    event TokensPurchased(address indexed purchaser, uint256 value, uint256 amount);

    constructor(uint256 _rate, uint256 _minInvestment, uint256 _maxInvestment, uint256 duration, address tokenAddress)
        Ownable(msg.sender)
    {
        require(_rate > 0, "Rate must be greater than 0");
        rate = _rate;
        minInvestment = _minInvestment;
        maxInvestment = _maxInvestment;
        endTime = block.timestamp + duration;
        token = SecurityToken(tokenAddress);
    }

    function invest() external payable nonReentrant {
        require(block.timestamp <= endTime, "Crowdsale ended");
        require(msg.value >= minInvestment, "Investment too small");
        require(investments[msg.sender] + msg.value <= maxInvestment, "Investment cap reached");

        uint256 tokenAmount = msg.value * rate;
        investments[msg.sender] += msg.value;

        token.transfer(msg.sender, tokenAmount);
        emit TokensPurchased(msg.sender, msg.value, tokenAmount);
    }

    function withdrawFunds() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
