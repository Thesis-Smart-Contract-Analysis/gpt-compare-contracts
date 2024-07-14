// https://chatgpt.com/share/5895b8a0-76f1-4444-89a7-4ba36b55dce1

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Balloons is ERC20 {
    constructor() ERC20("Balloons", "BAL") {
        _mint(msg.sender, 1000 * 10 ** 18);
    }
}

contract DecentralizedExchange {
    using SafeERC20 for IERC20;

    IERC20 public balloons;
    uint256 public totalLiquidity;
    mapping(address => uint256) public liquidity;

    event Initialized(uint256 totalLiquidity);
    event EthToBalSwap(
        address indexed sender,
        uint256 ethAmount,
        uint256 balAmount
    );
    event BalToEthSwap(
        address indexed sender,
        uint256 balAmount,
        uint256 ethAmount
    );
    event LiquidityDeposited(
        address indexed sender,
        uint256 liquidity,
        uint256 ethAmount,
        uint256 balAmount
    );
    event LiquidityWithdrawn(
        address indexed sender,
        uint256 liquidity,
        uint256 ethAmount,
        uint256 balAmount
    );

    constructor(address _balloons) {
        balloons = IERC20(_balloons);
    }

    function initialize(
        uint256 _tokenAmount
    ) external payable returns (uint256) {
        require(totalLiquidity == 0, "DEX: Already initialized");
        require(msg.value > 0, "DEX: Must send ETH");

        totalLiquidity = address(this).balance;
        liquidity[msg.sender] = totalLiquidity;

        balloons.safeTransferFrom(msg.sender, address(this), _tokenAmount);

        emit Initialized(totalLiquidity);
        return totalLiquidity;
    }

    function getPrice(
        uint256 inputAmount,
        uint256 inputReserve,
        uint256 outputReserve
    ) public pure returns (uint256) {
        uint256 inputAmountWithFee = inputAmount * 997;
        uint256 numerator = inputAmountWithFee * outputReserve;
        uint256 denominator = (inputReserve * 1000) + inputAmountWithFee;
        return numerator / denominator;
    }

    function ethToBal() external payable returns (uint256) {
        uint256 ethReserve = address(this).balance - msg.value;
        uint256 balReserve = balloons.balanceOf(address(this));
        uint256 balAmount = getPrice(msg.value, ethReserve, balReserve);

        balloons.safeTransfer(msg.sender, balAmount);

        emit EthToBalSwap(msg.sender, msg.value, balAmount);
        return balAmount;
    }

    function balToEth(uint256 _balAmount) external returns (uint256) {
        uint256 balReserve = balloons.balanceOf(address(this));
        uint256 ethReserve = address(this).balance;
        uint256 ethAmount = getPrice(_balAmount, balReserve, ethReserve);

        balloons.safeTransferFrom(msg.sender, address(this), _balAmount);
        payable(msg.sender).transfer(ethAmount);

        emit BalToEthSwap(msg.sender, _balAmount, ethAmount);
        return ethAmount;
    }

    function deposit() external payable returns (uint256) {
        require(msg.value > 0, "DEX: Must send ETH");
        uint256 ethReserve = address(this).balance - msg.value;
        uint256 balReserve = balloons.balanceOf(address(this));
        uint256 ethAmount = msg.value;
        uint256 balAmount = (ethAmount * balReserve) / ethReserve + 1;
        uint256 newLiquidity = (ethAmount * totalLiquidity) / ethReserve;

        liquidity[msg.sender] += newLiquidity;
        totalLiquidity += newLiquidity;

        balloons.safeTransferFrom(msg.sender, address(this), balAmount);

        emit LiquidityDeposited(msg.sender, newLiquidity, ethAmount, balAmount);
        return balAmount;
    }

    function withdraw(uint256 _liquidity) external returns (uint256, uint256) {
        require(_liquidity > 0, "DEX: Invalid liquidity amount");

        uint256 ethReserve = address(this).balance;
        uint256 balReserve = balloons.balanceOf(address(this));
        uint256 ethAmount = (_liquidity * ethReserve) / totalLiquidity;
        uint256 balAmount = (_liquidity * balReserve) / totalLiquidity;

        liquidity[msg.sender] -= _liquidity;
        totalLiquidity -= _liquidity;

        payable(msg.sender).transfer(ethAmount);
        balloons.safeTransfer(msg.sender, balAmount);

        emit LiquidityWithdrawn(msg.sender, _liquidity, ethAmount, balAmount);
        return (ethAmount, balAmount);
    }
}
