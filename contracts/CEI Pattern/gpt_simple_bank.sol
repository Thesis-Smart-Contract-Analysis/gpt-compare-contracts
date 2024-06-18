// https://chatgpt.com/share/1778e89b-a213-450d-8f4f-b33f2917336b

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleBank {
    address public owner;
    mapping(address => uint256) public balances;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only contract owner can call this function"
        );
        _;
    }

    function deposit(uint256 amount) external payable {
        require(amount > 0, "Deposit amount must be greater than zero");
        require(
            msg.value == amount,
            "Sent ether must be equal to deposit amount"
        );

        balances[msg.sender] += amount;
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Withdrawal amount must be greater than zero");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;

        // Effects - Interaction
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }

    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    // Owner function to withdraw contract balance
    function withdrawContractBalance() external onlyOwner {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "Contract balance is zero");

        // Effects - Interaction
        (bool success, ) = msg.sender.call{value: contractBalance}("");
        require(success, "Transfer failed");
    }

    // Fallback function to receive ether
    receive() external payable {}
}
