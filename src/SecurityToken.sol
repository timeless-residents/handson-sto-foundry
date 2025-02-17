// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

contract SecurityToken is ERC20, Ownable, Pausable {
    mapping(address => bool) public whitelist;

    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) ERC20(name, symbol) Ownable(msg.sender) {
        _mint(msg.sender, initialSupply);
    }

    function addToWhitelist(address investor) external onlyOwner {
        whitelist[investor] = true;
    }

    function removeFromWhitelist(address investor) external onlyOwner {
        whitelist[investor] = false;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function transfer(
        address to,
        uint256 amount
    ) public override whenNotPaused returns (bool) {
        require(whitelist[msg.sender] && whitelist[to], "Transfer restricted");
        return super.transfer(to, amount);
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override whenNotPaused returns (bool) {
        require(whitelist[from] && whitelist[to], "Transfer restricted");
        return super.transferFrom(from, to, amount);
    }
}
