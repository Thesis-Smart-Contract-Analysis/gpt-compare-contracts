Here is the Solidity code for the `DiceGame` smart contract based on the specifications provided:

```solidity
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

    event DiceRolled(address indexed player, uint256 rollResult, bool won, uint256 prizeWon);

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
            prizeAmount = (address(this).balance * PRIZE_RESET_SHARE) / PERCENTAGE_DIVISOR;
        } else {
            emit DiceRolled(msg.sender, rollResult, false, 0);
        }
        
        uint256 prizeFundShare = (msg.value * PRIZE_FUND_SHARE) / PERCENTAGE_DIVISOR;
        prizeAmount += prizeFundShare;
    }

    function calculateRollResult() internal returns (uint256) {
        uint256 roll = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), nonce))) % ROLL_MODULO;
        nonce++;
        return roll;
    }

    function fundPrize() internal {
        prizeAmount = (address(this).balance * PRIZE_RESET_SHARE) / PERCENTAGE_DIVISOR;
    }
}
```

Please note the following points about the contract:
- The contract is named `DiceGame`.
- The contract includes a `rollDice` function for players to roll the dice and try to win the prize.
- The contract includes a `fundPrize` function to set the initial prize amount and reset the prize amount after each win.
- The contract uses `receive` function to accept initial funding.
- The roll result is calculated by taking the keccak256 hash of the concatenated previous blockhash and nonce, then modding the result by 16.
- The contract emits an event `DiceRolled` when a player rolls the dice.
- The contract is designed to handle prize distribution, updating the prize amount, and tracking the winner address.
- The contract is written using Solidity version 0.8.0.

Please ensure to thoroughly test the contract on a testnet before deploying it to the mainnet to ensure its functionality and security.