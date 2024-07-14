// https://chatgpt.com/share/a32bc2b1-b054-4d03-8ce1-55bddd7dd749

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ExampleExternalContract {
    bool public completed;

    constructor() {
        completed = false;
    }

    function complete() public payable {
        completed = true;
    }
}

contract Staker {
    ExampleExternalContract public exampleExternalContract;
    mapping(address => uint256) public balances;
    uint256 public constant THRESHOLD = 1 ether;
    uint256 public deadline;
    bool public canWithdraw;

    event Stake(address indexed sender, uint256 amount);

    constructor(address exampleExternalContractAddress) {
        exampleExternalContract = ExampleExternalContract(
            exampleExternalContractAddress
        );
        deadline = block.timestamp + 72 hours;
        canWithdraw = false;
    }

    modifier checkCompletion() {
        if (block.timestamp > deadline) {
            if (address(this).balance >= THRESHOLD) {
                exampleExternalContract.complete{
                    value: address(this).balance
                }();
            } else {
                canWithdraw = true;
            }
        }
        _;
    }

    function stake() public payable checkCompletion {
        require(block.timestamp <= deadline, "Staking period is over");
        balances[msg.sender] += msg.value;
        emit Stake(msg.sender, msg.value);
    }

    function withdraw() public checkCompletion {
        require(canWithdraw, "Withdrawal is not allowed");
        uint256 balance = balances[msg.sender];
        require(balance > 0, "No balance to withdraw");
        balances[msg.sender] = 0;
        (bool sent, ) = msg.sender.call{value: balance}("");
        require(sent, "Failed to send Ether");
    }

    function timeLeft() public view returns (uint256) {
        if (block.timestamp >= deadline) {
            return 0;
        } else {
            return deadline - block.timestamp;
        }
    }

    receive() external payable {
        stake();
    }
}
