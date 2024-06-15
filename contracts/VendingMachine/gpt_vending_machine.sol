// https://chatgpt.com/share/bbc5d8f8-9f61-4a5b-b5c7-07eff2c9a246

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract VendingMachine {
    address public owner;
    uint256 public donutBalance;
    uint256 public constant donutPrice = 0.2 ether;

    mapping(address => uint256) public customerDonutBalances;

    event Restocked(uint256 amount);
    event Purchased(address indexed customer, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
        donutBalance = 100;
    }

    function restock(uint256 amount) public onlyOwner {
        donutBalance += amount;
        emit Restocked(amount);
    }

    function purchase(uint256 amount) public payable {
        require(amount > 0, "Amount must be greater than zero");
        require(msg.value == amount * donutPrice, "Incorrect Ether value sent");
        require(donutBalance >= amount, "Not enough donuts in stock");

        donutBalance -= amount;
        customerDonutBalances[msg.sender] += amount;

        emit Purchased(msg.sender, amount);
    }

    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    function getDonutBalance() public view returns (uint256) {
        return customerDonutBalances[msg.sender];
    }
}
