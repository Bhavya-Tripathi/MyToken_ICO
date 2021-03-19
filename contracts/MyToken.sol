// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;

contract MyToken{
    // Constructor: sets initial value of tokens
    // set the number of tokens
    // read the total number of tokens

    // name of token
    string public name = 'My Token';
    // symbol
    string public symbol = 'MYT';
    // standard
    string public standard = 'My token v1.0';

    uint public totalSupply;

    // declaring a transfer event
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint _value
    );

    // who has each token
    mapping(address => uint) public balanceOf;

    constructor(uint _initialSupply) public {
        balanceOf[msg.sender] = _initialSupply;
        totalSupply = _initialSupply;
        // allocate the initial supply
    }
    function Token () public view returns(uint)  {
       return totalSupply ;
    }
    // transfer function
    
    function transfer(address _to, uint _value) public returns(bool success){
   
    // throws excpetion if account doesn't have enough ether
    // require in solidity does the following: if the statement evaluates to true then continue function execution else stop function execution and throw error
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
     // triggers a transfer event
        emit Transfer(msg.sender, _to, _value);
    // return a boolean
        return true;
    }
}