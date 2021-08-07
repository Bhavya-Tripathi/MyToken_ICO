const MyToken = artifacts.require("MyToken");
const MyTokenSale = artifacts.require("MyTokenSale");

module.exports = function (deployer) {
  deployer.deploy(MyToken, 1000000).then(function(){
    // token price is 0.001 Ether
    var tokenPrice = 1000000000000000;
    // address of MyToken.sol contract needs to be passed in below contract
  return deployer.deploy(MyTokenSale, MyToken.address, tokenPrice);
  });
  
};
