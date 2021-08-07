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

    // approve event
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint _value
    );

    // who has each token
    mapping(address => uint) public balanceOf;

    // allowance
    // account A approves Account B to spend value, hence nested mappings
    mapping(address => mapping(address => uint)) public allowance;

    constructor(uint _initialSupply) public {
        balanceOf[msg.sender] = _initialSupply;
        totalSupply = _initialSupply;
        // allocate the initial supply
    }
  
    // transfer function
    
    function transfer(address _to, uint _value) public returns(bool success){
   
    // throws excpetion if account doesn't have enough tokens
    // require in solidity does the following: if the statement evaluates to true then continue function execution else stop function execution and throw error
        require(balanceOf[msg.sender] >= _value, "Not enough balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
     // triggers a transfer event
        emit Transfer(msg.sender, _to, _value);
    // return a boolean
        return true;
    }

    // Delegated Transfer

    // approve
    function approve(address _spender, uint _value) public returns(bool success) {
        // allowance
        allowance[msg.sender][_spender] = _value;
        // approvement
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // transferred From (transfer on behalf of other party)
    // three accounts, A -> calls the function, B -> account transferring the money, C-> moneny being transferred to
    function transferFrom(address _from, address _to, uint _value) public returns(bool success){
        // require _from has enough tokens
        require(_value <= balanceOf[_from], "Not enough money in spending account");
        // require allowance is big enough
        require(_value <= allowance[_from][msg.sender], "Value larger than approved amount");
        // call transfer event
        // change balance
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        // update allowance
        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }
}