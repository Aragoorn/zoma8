// SPDX-License-Identifier: MIT
pragma solidity 0.8.34;

contract BaseNFT {
    string public name = "Base Alpha NFT";
    string public symbol = "BAN";
    address public owner;
    uint256 public currentTokenId;

    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function mint(address _to) public onlyOwner returns (uint256) {
        currentTokenId++;
        uint256 newItemId = currentTokenId;
        
        _owners[newItemId] = _to;
        _balances[_to] += 1;

        emit Transfer(address(0), _to, newItemId);
        return newItemId;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        require(_owner != address(0), "Zero address query");
        return _balances[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address) {
        address tokenOwner = _owners[_tokenId];
        require(tokenOwner != address(0), "Token does not exist");
        return tokenOwner;
    }
}