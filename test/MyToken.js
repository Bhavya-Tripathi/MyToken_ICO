const MyToken = artifacts.require("MyToken");

contract('MyToken', function(accounts){
    it('sets the total supply upon deployment', function(){
        return MyToken.deployed().then(function(instance){
            tokenInstance = instance;
            return tokenInstance.totalSupply();
        }).then(function(totalSupply){
            assert.equal(totalSupply.toNumber(), 10, 'sets the total supply to 10');
        })
    })
})























