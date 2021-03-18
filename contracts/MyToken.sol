// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;

contract MyToken{
    // Constructor: sets initial value of tokens
    // set the number of tokens
    // read the total number of tokens
    uint public totalSupply =0;
    constructor() public {
        totalSupply = 10;
    }
    function Token () public view returns(uint)  {
       return totalSupply ;
    }
}