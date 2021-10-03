// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

//OpenZeppelin SafeMath, although might not be needed for compilers ^0.8.0 

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
contract TimeLock{ 
   
   //calling SafeMath functions 
    using SafeMath for uint;
    
    //map addresses to the deposited amounts
    mapping(address => uint)_balances;
    
    //map addressess to the time funds will be locked
    mapping(address => uint)_lockTime;
    
    //function for storing the deposited amounts for each address
    //Lock the funds for 1 week 
    function deposit() external payable{
        _balances[msg.sender] += msg.value;
        
        _lockTime[msg.sender] = block.timestamp + 1 weeks;
    }
    
    //If users wants to increase the lock time for funds
    function increment(uint _increasedLockTime) public {
        _lockTime[msg.sender] = _lockTime[msg.sender].add(_increasedLockTime);
    }
    
    function withdraw() public {
        //check if the caller has deposited funds before 
        //and funds are above 0
        require(_balances[msg.sender] > 0, "No Funds deposited");
        
        //check whether the lock time is up 
        require(_lockTime[msg.sender] < block.timestamp, "Time not up buddy!");
        
        //update the balance of the user to 0 and store the funds in amount
        uint _amount = _balances[msg.sender];
        _balances[msg.sender] = 0;
        
         //send funds back to the sender
        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Funds not withdrawn");
        
        
        
    }
    
    
    
}