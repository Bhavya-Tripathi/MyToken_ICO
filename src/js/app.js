App = {
    web3Provider: null,
    contracts: {},
    account: '0x',
    loading:false,
    tokenPrice: 1000000000000000,
    tokensSold: 0,
    tokensAvailable: 750000,

    init: function(){
        console.log("App initialized...")
        return App.initWeb3();
    },
    initWeb3: async function() {
        //----
        // Modern dapp browsers...
        if (window.ethereum) {
          App.web3Provider = window.ethereum;
          try {
            // Request account access
            await window.ethereum.enable();
          } catch (error) {
            // User denied account access...
            console.error("User denied account access")
          }
        }
        // Legacy dapp browsers...
        else if (window.web3) {
          App.web3Provider = window.web3.currentProvider;
        }
        // If no injected web3 instance is detected, fall back to Ganache
        else {
          App.web3Provider = new     Web3.providers.HttpProvider('http://localhost:7545');
        }
        web3 = new Web3(App.web3Provider);
        
        
        return App.initContract();
    },
    
    initContract: function(){
        $.getJSON("MyTokenSale.json", function(myTokenSale){
            App.contracts.MyTokenSale = TruffleContract(myTokenSale);
            App.contracts.MyTokenSale.setProvider(App.web3Provider);
            App.contracts.MyTokenSale.deployed().then(function(myTokenSale){
                console.log("My Token Sale Address:", myTokenSale.address);
            });
        }).done(function(){
                $.getJSON("MyToken.json", function(myToken){
                    App.contracts.MyToken = TruffleContract(myToken);
                    App.contracts.MyToken.setProvider(App.web3Provider);
                    App.contracts.MyToken.deployed().then(function(myToken){
                        console.log("My Token Address:", myToken.address);
                });
                App.listenForEvents();
                return App.render();
            });
        });
    },
    // listen for events emitted from the contract
    listenForEvents: function() {
        App.contracts.MyTokenSale.deployed().then(function(instance) {
          instance.Sell({}, {
            fromBlock: 0,
            toBlock: 'latest',
          }).watch(function(error, event) {
            console.log("event triggered", event);
            App.render();
          })
        })
      },
    

    render: function(){
        if(App.loading){
            return;
        }
        App.loading = true;

        var loader = $('#loader');
        var content = $('#content');

        loader.show();
        content.hide();

        // load account data
        web3.eth.getCoinbase(function(err, account){
            if(err === null){
                console.log("account", account);
                App.account = account;
                $('#accountAddress').html("Your Account: " + account);
            }
        })
        
        App.contracts.MyTokenSale.deployed().then(function(instance){
            myTokenSaleInstance = instance;
            console.log('working')
            return myTokenSaleInstance.tokenPrice();
        }).then(function(tokenPrice) {
            console.log("tokenPrice", tokenPrice.toNumber())
            App.tokenPrice = tokenPrice.toNumber();
            $('.token-price').html(web3.utils.fromWei(tokenPrice, "ether"));
            return myTokenSaleInstance.tokensSold();
        }).then(function(tokensSold){
            console.log("tokensSOld",tokensSold);
               App.tokensSold=tokensSold.toNumber();
               $(".tokens-sold").html(App.tokensSold);
               $(".tokens-available").html(App.tokensAvailable);
               var progressPercent = Math.ceil((App.tokensSold/App.tokensAvailable)*100);
               $('.progress-bar').css('width', `${progressPercent}%`);

            //    load token contract
            App.contracts.MyToken.deployed().then(function(instance){
                MyTokenInstance=instance;
                return MyTokenInstance.balanceOf(App.account);
            }).then(function(balance){
                $(".my-balance").html(balance.toNumber());
                
            })
        });
       
            App.loading = false;
            loader.hide();
            content.show();  
    },
    buyTokens:function(){
        App.loading=true;
        var loader=$("#loader");
        var content=$("#content");

        loader.show();
        content.hide();

        var numberOfTokens=$("#numberOfTokens").val();
        App.contracts.MyTokenSale.deployed().then(function(instance){
            return instance.buyTokens(numberOfTokens,{
                from:App.account,
                value:numberOfTokens * App.tokenPrice,
                gas:500000 //gas limit
            });
        }).then(function(result){
            console.log("Tokens bought....");
            $('form').trigger('reset') //reset number of tokens in form
            //wait for Sell event
        });

        App.loading=false;
        loader.hide();
        content.show();
    },
    listenForEvents:function(){
        App.contracts.MyTokenSale.deployed().then(function(instance){
            
              const listener = instance.Sell(
                {
                  fromBlock:0,
                  toBlock:'latest'
                },
                    function(error,event){
                        console.log("eventss",event)
                    }
              )
              console.log("$$$$$$$$$$$$$$$$$",listener)
           
        })
    }
}
$(function(){
    $(window).load(function(){
        App.init();
    })
});
