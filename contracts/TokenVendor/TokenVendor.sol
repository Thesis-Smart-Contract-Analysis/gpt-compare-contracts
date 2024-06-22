pragma solidity 0.8.20; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// learn more: https://docs.openzeppelin.com/contracts/4.x/erc20
import "@openzeppelin/contracts/access/Ownable.sol";

contract YourToken is ERC20 {
    constructor() ERC20("Gold", "GLD") {
        _mint(msg.sender, 2000 * 10 ** 18);
    }
}

contract Vendor is Ownable {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SellTokens(
        address seller,
        uint256 amountOfTokens,
        uint256 amountOfETH
    );

    YourToken public yourToken;

    constructor(address tokenAddress) Ownable(msg.sender) {
        yourToken = YourToken(tokenAddress);
    }

    uint256 public constant tokensPerEth = 100;

    // ToDo: create a payable buyTokens() function:
    function buyTokens() public payable {
        uint256 amountOfTokens = msg.value * tokensPerEth;
        yourToken.transfer(msg.sender, amountOfTokens);

        emit BuyTokens(msg.sender, msg.value, amountOfTokens);
    }

    // ToDo: create a withdraw() function that lets the owner withdraw ETH
    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    // ToDo: create a sellTokens(uint256 _amount) function:
    function sellTokens(uint256 amount) public {
        yourToken.transferFrom(msg.sender, address(this), amount);

        uint256 amountOfETH = amount / tokensPerEth;
        payable(msg.sender).transfer(amountOfETH);

        emit SellTokens(msg.sender, amount, amountOfETH);
    }
}
