// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Ballot} from "../contracts/Ballot/base_ballot.sol";

contract BallotTest is Test {
    Ballot public ballot;

    function setUp() public {
        bytes32[] memory proposalNames = new bytes32[](3);
        proposalNames[0] = "Proposal 1";
        proposalNames[1] = "Proposal 2";
        proposalNames[2] = "Proposal 3";
        ballot = new Ballot(proposalNames);
    }

    function test_giveRightToVote(address voter) public {
        ballot.giveRightToVote(voter);
        (uint weight, , , ) = ballot.voters(voter);
        assertEq(weight, 1);
    }

    function testFail_giveRightToVote(address voter) public {
        vm.startPrank(address(0x1));
        ballot.giveRightToVote(voter);
    }
}
