// SPDX-License-Identifier: MIT
pragma solidity 0.8.34;

contract BaseRegistry {
    address public owner;
    string public currentMessage;
    uint256 public totalUpdates;

    event MessageUpdated(address indexed user, string newMessage);

    constructor(string memory _initialMessage) {
        owner = msg.sender;
        currentMessage = _initialMessage;
        totalUpdates = 0;
    }

    function updateMessage(string memory _newMessage) public {
        currentMessage = _newMessage;
        totalUpdates += 1;
        emit MessageUpdated(msg.sender, _newMessage);
    }

    function getMessage() public view returns (string memory) {
        return currentMessage;
    }
}