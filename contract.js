if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    // set the provider you want from Web3.providers
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}

web3.eth.defaultAccount = web3.eth.accounts[0];

var HodlorContract = web3.eth.contract([
{
"constant": true,
"inputs": [
    {
        "name": "_input",
        "type": "uint256"
    }
],
"name": "getLn",
"outputs": [
    {
        "name": "",
        "type": "uint256"
    }
],
"payable": false,
"stateMutability": "pure",
"type": "function"
},
{
"constant": true,
"inputs": [
    {
        "name": "_gameId",
        "type": "uint256"
    }
],
"name": "checkState",
"outputs": [
    {
        "name": "",
        "type": "address[]"
    },
    {
        "name": "",
        "type": "uint256"
    },
    {
        "name": "",
        "type": "uint8"
    },
    {
        "name": "",
        "type": "uint256"
    },
    {
        "name": "",
        "type": "uint256"
    },
    {
        "name": "",
        "type": "bool[]"
    }
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": true,
"inputs": [
    {
        "name": "",
        "type": "uint256"
    }
],
"name": "games",
"outputs": [
    {
        "name": "betSize",
        "type": "uint256"
    },
    {
        "name": "gameState",
        "type": "uint8"
    },
    {
        "name": "poolPayoutOffset",
        "type": "uint256"
    },
    {
        "name": "timeStarted",
        "type": "uint256"
    }
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": false,
"inputs": [
    {
        "name": "_minBetSize",
        "type": "uint256"
    },
    {
        "name": "_maxBetSize",
        "type": "uint256"
    },
    {
        "name": "_lostToPlayerPercent",
        "type": "uint256"
    },
    {
        "name": "_lostToPoolPercent",
        "type": "uint256"
    }
],
"name": "modifyVars",
"outputs": [],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
},
{
"constant": true,
"inputs": [],
"name": "totalAmount",
"outputs": [
    {
        "name": "",
        "type": "uint256"
    }
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": false,
"inputs": [
    {
        "name": "_gameId",
        "type": "uint256"
    }
],
"name": "askForDraw",
"outputs": [],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
},
{
"constant": true,
"inputs": [
    {
        "name": "",
        "type": "address"
    }
],
"name": "points",
"outputs": [
    {
        "name": "",
        "type": "uint256"
    }
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": false,
"inputs": [],
"name": "withdraw",
"outputs": [],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
},
{
"constant": false,
"inputs": [],
"name": "unpause",
"outputs": [],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
},
{
"constant": false,
"inputs": [
    {
        "name": "_gameId",
        "type": "uint256"
    }
],
"name": "leaveGame",
"outputs": [],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
},
{
"constant": true,
"inputs": [],
"name": "maxBetSize",
"outputs": [
    {
        "name": "",
        "type": "uint256"
    }
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": false,
"inputs": [
    {
        "name": "_player2",
        "type": "address"
    }
],
"name": "createGame",
"outputs": [],
"payable": true,
"stateMutability": "payable",
"type": "function"
},
{
"constant": true,
"inputs": [],
"name": "paused",
"outputs": [
    {
        "name": "",
        "type": "bool"
    }
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": true,
"inputs": [],
"name": "minBetSize",
"outputs": [
    {
        "name": "",
        "type": "uint256"
    }
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": false,
"inputs": [
    {
        "name": "_gameId",
        "type": "uint256"
    }
],
"name": "cancelGame",
"outputs": [],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
},
{
"constant": false,
"inputs": [],
"name": "pause",
"outputs": [],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
},
{
"constant": true,
"inputs": [
    {
        "name": "",
        "type": "address"
    }
],
"name": "totalWinnings",
"outputs": [
    {
        "name": "",
        "type": "uint256"
    }
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": true,
"inputs": [],
"name": "owner",
"outputs": [
    {
        "name": "",
        "type": "address"
    }
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": false,
"inputs": [
    {
        "name": "_gameId",
        "type": "uint256"
    }
],
"name": "acceptDraw",
"outputs": [],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
},
{
"constant": true,
"inputs": [],
"name": "poolPayout",
"outputs": [
    {
        "name": "",
        "type": "uint256"
    }
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": true,
"inputs": [],
"name": "totalNumberOfGames",
"outputs": [
    {
        "name": "",
        "type": "uint256"
    }
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": true,
"inputs": [],
"name": "lostToPoolPercent",
"outputs": [
    {
        "name": "",
        "type": "uint256"
    }
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": true,
"inputs": [
    {
        "name": "_Meps",
        "type": "uint256"
    }
],
"name": "getShare",
"outputs": [
    {
        "name": "Mshare",
        "type": "uint256"
    }
],
"payable": false,
"stateMutability": "pure",
"type": "function"
},
{
"constant": true,
"inputs": [],
"name": "lostToPlayerPercent",
"outputs": [
    {
        "name": "",
        "type": "uint256"
    }
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": false,
"inputs": [
    {
        "name": "_gameId",
        "type": "uint256"
    }
],
"name": "joinGame",
"outputs": [],
"payable": true,
"stateMutability": "payable",
"type": "function"
},
{
"constant": false,
"inputs": [
    {
        "name": "newOwner",
        "type": "address"
    }
],
"name": "transferOwnership",
"outputs": [],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
},
{
"payable": true,
"stateMutability": "payable",
"type": "fallback"
},
{
"anonymous": false,
"inputs": [
    {
        "indexed": false,
        "name": "gameId",
        "type": "uint256"
    }
],
"name": "GameCreated",
"type": "event"
},
{
"anonymous": false,
"inputs": [
    {
        "indexed": false,
        "name": "gameId",
        "type": "uint256"
    }
],
"name": "GameUpdated",
"type": "event"
},
{
"anonymous": false,
"inputs": [
    {
        "indexed": false,
        "name": "_address",
        "type": "address"
    },
    {
        "indexed": false,
        "name": "_amount",
        "type": "uint256"
    }
],
"name": "MoneyWithdrew",
"type": "event"
},
{
"anonymous": false,
"inputs": [],
"name": "Pause",
"type": "event"
},
{
"anonymous": false,
"inputs": [],
"name": "Unpause",
"type": "event"
},
{
"anonymous": false,
"inputs": [
    {
        "indexed": true,
        "name": "previousOwner",
        "type": "address"
    },
    {
        "indexed": true,
        "name": "newOwner",
        "type": "address"
    }
],
"name": "OwnershipTransferred",
"type": "event"
}
]
);

var Hodlor = HodlorContract.at('0xd9f792fd5917556a3d5fa57606b1f2914cec70fd');
console.log(Hodlor);
