// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DiceGame {
    uint256 constant ROLL_MODULO = 16;
    uint256 constant PERCENTAGE_DIVISOR = 100;
    uint256 constant PRIZE_PERCENTAGE = 10;
    uint256 constant PRIZE_FUND_PERCENTAGE = 90;
    uint256 constant PRIZE_FUND_SHARE = 40;
    uint256 constant PRIZE_RESET_SHARE = 10;

    uint256 public prizeAmount = 0.05 ether;
    address public winner;
    uint256 public nonce = 0;

    event DiceRolled(
        address indexed player,
        uint256 rollResult,
        bool won,
        uint256 prizeWon
    );

    constructor() payable {
        fundPrize();
    }

    receive() external payable {
        fundPrize();
    }

    function rollDice() external payable {
        require(msg.value >= 0.002 ether, "Insufficient bet amount");

        uint256 rollResult = calculateRollResult();
        bool won = (rollResult <= 5);

        if (won) {
            address payable player = payable(msg.sender);
            uint256 prizeWon = prizeAmount;
            player.transfer(prizeWon);
            winner = player;
            emit DiceRolled(player, rollResult, true, prizeWon);
            prizeAmount =
                (address(this).balance * PRIZE_RESET_SHARE) /
                PERCENTAGE_DIVISOR;
        } else {
            emit DiceRolled(msg.sender, rollResult, false, 0);
        }

        uint256 prizeFundShare = (msg.value * PRIZE_FUND_SHARE) /
            PERCENTAGE_DIVISOR;
        prizeAmount += prizeFundShare;
    }

    function calculateRollResult() internal returns (uint256) {
        uint256 roll = uint256(
            keccak256(abi.encodePacked(blockhash(block.number - 1), nonce))
        ) % ROLL_MODULO;
        nonce++;
        return roll;
    }

    function fundPrize() internal {
        prizeAmount =
            (address(this).balance * PRIZE_RESET_SHARE) /
            PERCENTAGE_DIVISOR;
    }
}
