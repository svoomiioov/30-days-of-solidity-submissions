//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

contract AdminOnly{

    address public owner;
    uint256 public treasureAmount;
    mapping (address => uint256)public withdrawalAllowance;
    mapping (address => bool) hasWithdrawn;

    constructor(){

        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Access denied: Only the owner can perform this action");
        _;
    }    

    function addTreasure(uint256 amount) public onlyOwner{

        //require(msg.sender == owrner, "Access denied: Only the owner can perform this action");

        //if this condition passes continue to function logic,
        treasureAmount += amount;
    }

    function approveWithdrawal(address recipient, uint256 amount) public onlyOwner{
        require(amount <= treasureAmount, "Insufficient funds in the contract");
        withdrawalAllowance[recipient] = amount;

    }

    function withdrawTreasure(uint256 amount)public {
        if(msg.sender == owner){
            require(amount <= treasureAmount, "Insufficient funds in the contract");
            treasureAmount-= amount;
            return;
        } 

        uint256 allowance = withdrawalAllowance[msg.sender];

        require(allowance > 0, "You do not have any treasure allowance");
        require(!hasWithdrawn[msg.sender], "You have already withdrawan your treasure");
        require(allowance <=treasureAmount, "Not enough treasure in the chest");
        require(amount <= allowance, "Not enough allowance for withdrawl");


        hasWithdrawn[msg.sender] = true;
        treasureAmount -= allowance;
        withdrawalAllowance[msg.sender] = 0;
    }

    function resetWithdrawalStatus(address user) public onlyOwner{
        hasWithdrawn[user] = false;
    }

    function transferOwnership(address newOwner)public onlyOwner{
        require(newOwner != address(0), "Invalid new owner");
        owner = newOwner;
    }

    function getTreasureDetails() public view onlyOwner returns(uint256){      
       return treasureAmount;
    } 

}
