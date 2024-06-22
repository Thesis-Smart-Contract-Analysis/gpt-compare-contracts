// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract YourToken is ERC20 {
    constructor() ERC20("Gold", "GLD") {
        _mint(msg.sender, 2000 * 10 ** 18);
    }
}

contract Vendor is Ownable {
    ERC20 public token;
    uint public price = 100; // 100 tokens per 1 ether

    event TokensPurchased(
        address indexed user,
        uint ethAmount,
        uint tokenAmount
    );
    event TokensSold(address indexed user, uint tokenAmount, uint ethAmount);

    constructor(address _token) Ownable(msg.sender) {
        token = ERC20(_token);
    }

    function buyTokens() public payable {
        uint tokenAmount = msg.value * price;
        require(
            token.balanceOf(address(this)) >= tokenAmount,
            "Insufficient token balance in contract"
        );

        token.transfer(msg.sender, tokenAmount);
        emit TokensPurchased(msg.sender, msg.value, tokenAmount);
    }

    function sellTokens(uint _amount) public {
        require(
            token.balanceOf(msg.sender) >= _amount,
            "Insufficient token balance"
        );

        token.transferFrom(msg.sender, address(this), _amount);
        uint ethAmount = _amount / price;
        payable(msg.sender).transfer(ethAmount);
        emit TokensSold(msg.sender, _amount, ethAmount);
    }

    function withdraw() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
