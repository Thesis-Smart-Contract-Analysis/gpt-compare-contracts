// https://chatgpt.com/share/af0db6a9-9396-49c1-922a-e74e95518d8f

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DiceGame {
    uint256 public currentPrize;
    uint256 public nonce;
    address public owner;

    event Roll(address indexed player, uint256 result, uint256 prizeWon);

    constructor() payable {
        require(
            msg.value >= 0.05 ether,
            "Initial funding must be at least 0.05 ETH"
        );
        owner = msg.sender;
        currentPrize = address(this).balance / 10;
    }

    receive() external payable {}

    function roll() external payable {
        require(
            msg.value == 0.002 ether,
            "Must send exactly 0.002 ETH to roll"
        );

        // Update current prize with 40% of the bet
        uint256 prizeContribution = (msg.value * 40) / 100;
        currentPrize += prizeContribution;

        // Generate the roll result
        bytes32 hash = keccak256(
            abi.encodePacked(blockhash(block.number - 1), nonce)
        );
        uint256 rollResult = uint256(hash) % 16;
        nonce++;

        // If the roll is a win (0-5), transfer the prize
        if (rollResult < 6) {
            uint256 prizeToTransfer = currentPrize;
            currentPrize = address(this).balance / 10;
            (bool success, ) = msg.sender.call{value: prizeToTransfer}("");
            require(success, "Transfer failed");
            emit Roll(msg.sender, rollResult, prizeToTransfer);
        } else {
            emit Roll(msg.sender, rollResult, 0);
        }
    }

    // Function to fund the contract initially
    function fundContract() external payable onlyOwner {
        require(msg.value > 0, "Must send ETH to fund the contract");
        currentPrize = address(this).balance / 10;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
}
