// https://chatgpt.com/share/d7c5e080-d917-4ec4-a7ec-c461e3b2dc1a

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract Lottery {
    address public owner;
    uint256 public betAmount = 0.01 ether; // Minimum bet amount
    address[] public players; // Array to store players

    constructor() {
        owner = msg.sender; // Set the contract deployer as the owner
    }

    // Modifier to restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function.");
        _;
    }

    // Function to allow players to enter the lottery
    function enter() external payable {
        require(msg.value > betAmount, "Insufficient bet amount.");
        players.push(msg.sender); // Add the player to the list of players
    }

    // Function to get the number of players
    function getNumberOfPlayers() external view returns (uint256) {
        return players.length;
    }

    // Function for the owner to select a winner randomly
    function selectWinner() external onlyOwner {
        require(players.length > 0, "No players participated in the lottery.");
        
        // Generate a random index based on block difficulty and current time
        uint256 randIndex = random() % players.length;
        address winner = players[randIndex];
        
        // Transfer the contract balance to the winner
        payable(winner).transfer(address(this).balance);
        
        // Reset the lottery for the next round
        delete players;
    }

    // Internal function to generate a pseudo-random number
    function random() internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    // Fallback function to receive ETH
    receive() external payable {}

    // Function to withdraw any remaining balance (in case of emergency)
    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
