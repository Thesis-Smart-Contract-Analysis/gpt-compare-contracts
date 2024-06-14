// https://github.com/jspruance/block-explorer-tutorials/blob/main/smart-contracts/solidity/Lottery.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

contract Lottery {
    address public owner;
    address payable[] public players;

    constructor() {
        owner = msg.sender;
    }

    function enter() public payable {
        require(msg.value > 0.01 ether, "Minimum bet is 0.01 ETH.");
        // address of player entering lottery
        players.push(payable(msg.sender));
    }

    function getRandomNumber() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    function pickWinner() public onlyowner {
        require(players.length > 0, "No players participated in the current round.");

        uint index = getRandomNumber() % players.length;
        players[index].transfer(address(this).balance);        

        // reset the state of the contract
        players = new address payable[](0);
    }

    modifier onlyowner() {
        require(msg.sender == owner, "Only the contract owner can call this function.");
        _;
    }
}