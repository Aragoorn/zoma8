// SPDX-License-Identifier: MIT
pragma solidity 0.8.34;

contract BaseVoting {
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    address public admin;
    mapping(address => bool) public hasVoted;
    mapping(uint256 => Candidate) public candidates;
    uint256 public candidatesCount;

    constructor() {
        admin = msg.sender;
        addCandidate("Proposal 1");
        addCandidate("Proposal 2");
    }

    function addCandidate(string memory _name) private {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote(uint256 _candidateId) public {
        require(!hasVoted[msg.sender], "Already voted.");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid option.");

        hasVoted[msg.sender] = true;
        candidates[_candidateId].voteCount++;
    }
}