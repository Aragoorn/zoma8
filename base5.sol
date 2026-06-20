// SPDX-License-Identifier: MIT
pragma solidity 0.8.34;

contract BaseTodoList {
    struct Task {
        uint256 id;
        string content;
        bool isCompleted;
    }

    address public owner;
    uint256 public taskCount;
    mapping(uint256 => Task) public tasks;

    event TaskCreated(uint256 id, string content, bool isCompleted);
    event TaskCompleted(uint256 id, bool isCompleted);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        createTask("Deploy my first contract on Base");
    }

    function createTask(string memory _content) public onlyOwner {
        taskCount++;
        tasks[taskCount] = Task(taskCount, _content, false);
        emit TaskCreated(taskCount, _content, false);
    }

    function toggleCompleted(uint256 _id) public onlyOwner {
        require(_id > 0 && _id <= taskCount, "Task does not exist");
        Task storage _task = tasks[_id];
        _task.isCompleted = !_task.isCompleted;
        emit TaskCompleted(_id, _task.isCompleted);
    }

    function getTask(uint256 _id) public view returns (uint256, string memory, bool) {
        require(_id > 0 && _id <= taskCount, "Task does not exist");
        Task memory _task = tasks[_id];
        return (_task.id, _task.content, _task.isCompleted);
    }
}