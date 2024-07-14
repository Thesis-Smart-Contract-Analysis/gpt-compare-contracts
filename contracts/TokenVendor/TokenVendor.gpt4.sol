// https://chatgpt.com/share/ec4d7505-b2ae-4cdf-8e99-228540090999

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract YourToken is ERC20 {
    constructor() ERC20("Gold", "GLD") {
        _mint(msg.sender, 2000 * 10 ** 18);
    }
}

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Vendor is Ownable {
    IERC20 public token;
    uint256 public constant tokensPerEth = 100;

    event TokensPurchased(
        address indexed buyer,
        uint256 amountOfETH,
        uint256 amountOfTokens
    );
    event TokensSold(
        address indexed seller,
        uint256 amountOfTokens,
        uint256 amountOfETH
    );

    constructor(address tokenAddress) Ownable(msg.sender) {
        token = IERC20(tokenAddress);
    }

    function buyTokens() public payable {
        uint256 tokenAmount = msg.value * tokensPerEth;
        require(
            token.balanceOf(address(this)) >= tokenAmount,
            "Vendor: Not enough tokens in the reserve"
        );

        token.transfer(msg.sender, tokenAmount);
        emit TokensPurchased(msg.sender, msg.value, tokenAmount);
    }

    function sellTokens(uint256 tokenAmount) public {
        require(
            token.balanceOf(msg.sender) >= tokenAmount,
            "Vendor: Not enough tokens to sell"
        );

        uint256 ethAmount = tokenAmount / tokensPerEth;
        require(
            address(this).balance >= ethAmount,
            "Vendor: Not enough ETH in the reserve"
        );

        token.transferFrom(msg.sender, address(this), tokenAmount);
        payable(msg.sender).transfer(ethAmount);

        emit TokensSold(msg.sender, tokenAmount, ethAmount);
    }

    function withdraw() public onlyOwner {
        uint256 contractBalance = address(this).balance;
        payable(owner()).transfer(contractBalance);
    }
}
