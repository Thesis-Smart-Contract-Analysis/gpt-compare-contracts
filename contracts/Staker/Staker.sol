// SPDX-License-Identifier: MIT
pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading

import "hardhat/console.sol";

contract ExampleExternalContract {
    bool public completed;

    function complete() public payable {
        completed = true;
    }
}

contract Staker {
    ExampleExternalContract public exampleExternalContract;

    constructor(address exampleExternalContractAddress) {
        exampleExternalContract = ExampleExternalContract(
            exampleExternalContractAddress
        );
    }

    // Track a constant threshold at 1 ether
    uint256 public constant threshold = 1 ether;

    // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
    mapping(address => uint256) public balances;

    // Make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display
    event Stake(address, uint256);

    function stake() public payable {
        balances[msg.sender] += msg.value;
        emit Stake(msg.sender, msg.value);
    }

    modifier notCompleted() {
        require(
            exampleExternalContract.completed() == false,
            "Contract already completed"
        );
        _;
    }

    // After some `deadline` allow anyone to call an `execute()` function
    uint256 public deadline = block.timestamp + 72 hours;

    // Add a `bool` field `openForWithdraw` that tracks whether the contract is open for withdrawal or not
    bool public openForWithdraw = false;

    function execute() public notCompleted {
        if (block.timestamp >= deadline) {
            // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`
            if (address(this).balance >= threshold) {
                exampleExternalContract.complete{
                    value: address(this).balance
                }();
            }
            // If the `threshold` was not met, allow everyone to call a `withdraw()` function to withdraw their balance
            else {
                openForWithdraw = true;
            }
        }
    }

    // Add a `withdraw()` function to withdraw the balance from the contract
    function withdraw() public notCompleted {
        require(openForWithdraw == true, "Not open for withdraw yet");

        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;

        payable(msg.sender).transfer(amount);
    }

    // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
    function timeLeft() public view returns (uint256) {
        if (block.timestamp >= deadline) {
            return 0;
        } else {
            return deadline - block.timestamp;
        }
    }

    // Add the `receive()` special function that receives eth and calls stake()
    receive() external payable {
        stake();
    }
}
