// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;
contract VotingSystem {
    // Define variables and data structures
    struct Voter {
        bool voted;
        uint256 vote;
    }

    mapping(address => Voter) public voters;
    mapping(uint256 => uint256) public voteCounts;
    address public admin;
    uint256 public numberOfVotes;
    uint256 public winningProposal;

    // Define events
    event VoteCast(address indexed voter, uint256 vote);
    event ElectionResult(uint256 winningProposal, uint256 winningProposalVotes);

    // Constructor function
    constructor() {
        admin = msg.sender;
        numberOfVotes = 0;
    }

    // Define voting functions
    function vote(uint256 proposal) public {
        require(voters[msg.sender].voted == false, "Already voted.");
        voters[msg.sender].voted = true;
        voters[msg.sender].vote = proposal;
        voteCounts[proposal]++;

        numberOfVotes++;
        emit VoteCast(msg.sender, proposal);
    }

    // Define administrative functions
    function endVoting() public {
        require(msg.sender == admin, "Only admin can end voting.");
        uint256 winningVoteCount = 0;
        for (uint256 i = 0; i < numberOfVotes; i++) {
            if (voteCounts[i] > winningVoteCount) {
                winningVoteCount = voteCounts[i];
                winningProposal = i;
            }
        }

        emit ElectionResult(winningProposal, winningVoteCount);
    }

    function reset() public {
        require(msg.sender == admin, "Only admin can reset voting system.");

        for (uint256 i = 0; i < numberOfVotes; i++) {
            voteCounts[i] = 0;
        }
        numberOfVotes = 0;
        winningProposal = 0;
    }
}
