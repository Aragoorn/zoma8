// SPDX-License-Identifier: MIT
pragma solidity 0.8.34;

contract BaseVaultV2 {
    address public owner;
    // تغییر در ساختار برای متمایز شدن بایت‌کد در بیس‌اسکن
    string public contractVersion = "2.0.0"; 

    event Deposited(address indexed sender, uint256 amount);
    event Withdrawn(uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        if (msg.value > 0) {
            emit Deposited(msg.sender, msg.value);
        }
    }

    function deposit() public payable {
        require(msg.value > 0, "Send some ETH");
        emit Deposited(msg.sender, msg.value);
    }

    function withdrawAll() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Vault is empty");
        
        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Transfer failed");
        
        emit Withdrawn(balance);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}