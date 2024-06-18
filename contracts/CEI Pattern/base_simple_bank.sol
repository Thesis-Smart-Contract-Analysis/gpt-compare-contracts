// https://detectors.auditbase.com/checks-effects-interactions

// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract SimpleBankWithEIC {
    mapping(address => uint) public balances;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        // Checks
        require(msg.value > 0, "Value should be greater than 0");

        // Effects
        balances[msg.sender] += msg.value;

        // Interactions (In this case, there's no external call,
        // but it's good to keep the pattern in mind)
    }

    function withdraw(uint amount) public {
        // Checks
        require(amount > 0, "Deposit amount must be greater than zero");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        // Effects
        balances[msg.sender] -= amount;

        // Effects - Interaction
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }
}
