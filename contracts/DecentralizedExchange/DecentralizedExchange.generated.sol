// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Balloons is ERC20 {
    constructor() ERC20("Balloons", "BAL") {
        _mint(msg.sender, 1000 * 10 ** 18);
    }
}

contract DecentralizedExchange {
    Balloons public balloonsToken;

    uint public totalLiquidity;
    mapping(address => uint) public userLiquidity;

    constructor(address _balloonsToken) {
        balloonsToken = Balloons(_balloonsToken);
    }

    function initialize(uint amount) public payable returns (uint) {
        require(msg.value == amount, "Incorrect ETH amount sent");
        balloonsToken.transferFrom(msg.sender, address(this), amount);

        totalLiquidity = address(this).balance;
        userLiquidity[msg.sender] = totalLiquidity;

        return totalLiquidity;
    }

    function calculatePrice(
        uint amountX,
        uint reserveX,
        uint reserveY
    ) public pure returns (uint) {
        uint fee = (amountX * 997) / 1000;
        uint amountXAfterFee = amountX - fee;

        return (reserveY * amountXAfterFee) / (reserveX + amountXAfterFee);
    }

    function swapEthForBal() public payable returns (uint) {
        uint amountOut = calculatePrice(
            msg.value,
            address(this).balance - msg.value,
            balloonsToken.balanceOf(address(this))
        );

        balloonsToken.transfer(msg.sender, amountOut);

        emit Swap(msg.sender, "ETH to BAL", msg.value, amountOut);

        return amountOut;
    }

    function swapBalForEth(uint amount) public returns (uint) {
        uint amountOut = calculatePrice(
            amount,
            balloonsToken.balanceOf(address(this)),
            address(this).balance
        );

        balloonsToken.transferFrom(msg.sender, address(this), amount);
        payable(msg.sender).transfer(amountOut);

        emit Swap(msg.sender, "BAL to ETH", amountOut, amount);

        return amountOut;
    }

    function deposit() public payable returns (uint) {
        uint ethLiquidity = (msg.value * totalLiquidity) /
            (address(this).balance - msg.value);
        totalLiquidity += ethLiquidity;
        userLiquidity[msg.sender] += ethLiquidity;

        uint balAmount = ((msg.value * balloonsToken.balanceOf(address(this))) /
            (address(this).balance - msg.value)) + 1;
        balloonsToken.transferFrom(msg.sender, address(this), balAmount);

        emit Deposit(msg.sender, ethLiquidity, msg.value, balAmount);

        return balAmount;
    }

    function withdraw(uint liquidity) public returns (uint, uint) {
        uint ethAmount = (liquidity * address(this).balance) / totalLiquidity;
        uint balAmount = (liquidity * balloonsToken.balanceOf(address(this))) /
            totalLiquidity;

        totalLiquidity -= liquidity;
        userLiquidity[msg.sender] -= liquidity;

        payable(msg.sender).transfer(ethAmount);
        balloonsToken.transfer(msg.sender, balAmount);

        emit Withdraw(msg.sender, liquidity, ethAmount, balAmount);

        return (ethAmount, balAmount);
    }

    event Swap(
        address indexed user,
        string action,
        uint amountEth,
        uint amountBal
    );
    event Deposit(
        address indexed user,
        uint liquidity,
        uint amountEth,
        uint amountBal
    );
    event Withdraw(
        address indexed user,
        uint liquidity,
        uint amountEth,
        uint amountBal
    );
}
