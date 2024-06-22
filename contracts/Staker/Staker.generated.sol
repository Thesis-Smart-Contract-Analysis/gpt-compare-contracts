// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ExampleExternalContract {
    bool public isStakingOver = false;

    function complete() external payable {
        require(msg.value > 0, "Invalid amount sent");
        isStakingOver = true;
    }
}

contract Staker {
    address public externalContract;
    uint256 public deadline;
    bool public allowWithdrawal = false;
    uint256 public threshold = 1 ether;

    mapping(address => uint256) public balances;

    modifier onlyWhenStakingComplete() {
        ExampleExternalContract extContract = ExampleExternalContract(
            externalContract
        );
        require(extContract.isStakingOver(), "Staking is not yet completed");
        _;
    }

    constructor(address _externalContract) {
        externalContract = _externalContract;
        deadline = block.timestamp + 72 hours;
    }

    event Stake(address indexed staker, uint256 amount);

    function stake() external payable {
        require(msg.value > 0, "Invalid amount sent");
        balances[msg.sender] += msg.value;
        emit Stake(msg.sender, msg.value);
    }

    function completeStaking() public onlyWhenStakingComplete {
        if (block.timestamp > deadline) {
            if (address(this).balance >= threshold) {
                ExampleExternalContract extContract = ExampleExternalContract(
                    externalContract
                );
                extContract.complete{value: address(this).balance}();
            } else {
                allowWithdrawal = true;
            }
        }
    }

    function withdraw() public onlyWhenStakingComplete {
        require(allowWithdrawal, "Withdrawal not allowed yet");
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No balance to withdraw");
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function timeLeftForDeadline() public view returns (uint256) {
        if (block.timestamp > deadline) {
            return 0;
        } else {
            return deadline - block.timestamp;
        }
    }

    receive() external payable {
        this.stake(); // ❌ syntax error: used to be staked() before
    }
}
