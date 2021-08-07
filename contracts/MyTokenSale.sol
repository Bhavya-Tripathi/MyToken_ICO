// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;
// pragma solidity >=0.5.0 <0.9.0;


import "./MyToken.sol";

contract MyTokenSale{
    // the admin address isn't kept public, we don't wanna expose it 
    address payable admin;
    MyToken public tokenContract;
    uint public tokenPrice;
    uint public tokensSold;

    event Sell( address _buyer, uint _amount);

    constructor(MyToken _tokenContract, uint _tokenPrice) public{
        // assign an admin
        admin = msg.sender;
        // admin can end token sale
        // Token contract
        tokenContract = _tokenContract;
        // Token price(how much ether it costs to sell token)
        tokenPrice = _tokenPrice;
        
    }
    // multiply
    function multiply(uint x, uint y) internal pure returns(uint z) {
        require(y == 0 || (z = x*y)/y ==x);
    }
    // Buy Tokens
    function buyTokens(uint _numberOfTokens) public payable{
        // Require that the value is equal to tokens
        require(msg.value == multiply(_numberOfTokens , tokenPrice), "Pay the right amount");
        // Require that the contract has enough tokens
        require(tokenContract.balanceOf(address(this)) >= _numberOfTokens, "The contract does not have enough tokens");
        // Require that transfer is successful
        require(tokenContract.transfer(msg.sender, _numberOfTokens), "Require that a transfer is successful");
        // keep track of the tokens sold
        tokensSold += _numberOfTokens;
        // trigger sell event
        emit Sell(msg.sender, _numberOfTokens);

    }

    // Ending the token sale
    function endSale() public{
        // Require that only an admin can do this
        require(msg.sender == admin, 'Only the admin can end a sale');
        // Transfer the remaining amount of tokens in the sale back to the admin
        require(tokenContract.transfer(admin, tokenContract.balanceOf(address(this))), 'Return all unsold tokens to admin');
        // Destroy the contract
        // selfdestruct(payable(address(admin)));
        selfdestruct(admin);
        // instead of destroying the contract we transfer the tokens to  the admin
        // payable(admin).transfer(address(this).balance);
    }
}
