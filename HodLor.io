pragma solidity ^0.4.0;
contract Ownable {
  address public owner;
  
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  function Ownable() public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
}

contract Hodl is Ownable{
    
//In theory not needed as all cases of over/underflowed are handled
//but one can never be too safe...
using SafeMath for uint256;    

//events for game creations etc. for web3 integration
event GameCreated(uint gameId, uint betSize, address[] players);
event GameStarted(uint gameId, uint betSize, address[] players);
event GameCanceled(uint gameId, uint betSize, address[] players);
event GameFinished(uint gameId, uint betSize, address[] players);
event MoneyWithdrew(address _address,uint _amount);

//Minimum and maximum bet sizes.   
uint public minBetSize=0.01 ether;
uint public maxBetSize=10 ether;

//Developper's fee. 1% of betsize (0.05% of total game value)
uint devCutPercent=1;

// percentages of betsize given by losing player to opponent and to pool 
uint public lostToPlayerPercent=10;
uint public lostToPoolPercent=5;

//payout per ether per game
uint public poolPayout=0;
    
//total ether in play
uint public totalAmount=0;
    
//total winnings stores all of playes' winnings from finished games. withdraw() can be called at any time from user to have their eth sent to their address
mapping(address=>uint) totalWinnings;
    
struct Game {
    
    //players[0] is game creator and player[1] is the second player who joined
    address[] players;
    
    // bet size for each player (same)
    uint betSize;
    
    //gameState=1 if created and waiting for second player.  =2 if game in play =0 if cancelled.
    uint8 gameState;
    
    //Offset to make sure the game gets the right amount of pooled money when closed. poolPayout keeps going up everytime a game is closed. Every new game starts with poolPayoutOffset equal to current poolPayout
    uint poolPayoutOffset;
}

    // owner only function to change game variables
    function modifyVars(uint _minBetSize,uint _maxBetSize,uint _lostToPlayerPercent, uint _lostToPoolPercent) external onlyOwner{
        minBetSize=_minBetSize;
        maxBetSize=_maxBetSize;
        lostToPlayerPercent=_lostToPlayerPercent;
        lostToPoolPercent=_lostToPoolPercent;
    }
    
    //checks if game has been created but not started. Checks before joining or cancelling a game
    modifier createdNotStarted(uint _gameId) {
        require(games[_gameId].gameState==1);
        _;
    }

    //checks if game is running ie both players have sent betSize to game and noone has left yet. Also checks if msg.sender is one the players. Checks before leaving a game.
    modifier Playing(uint _gameId) {
        require(games[_gameId].gameState==2);
        require(msg.sender==games[_gameId].players[0]||msg.sender==games[_gameId].players[1]);
        _;
    } 
    
    //checks for correct betSizes. only multiples of 100Wei allowed to not deal with small numbers. 
    modifier isValidStartBet(){
        require((msg.value>=minBetSize)&&(msg.value<=maxBetSize)&&(msg.value%100==0));
        _;
    }
    
    Game[] public games;
    
    //Anyone can create a game by sending a valid amount and calling createGame(). Funds do not go to totalWinnings but can be immediatly retrieved by cancelling the game. Every new game gets a uint id incremented.
    function createGame() public payable isValidStartBet(){
        uint id = games.push(Game(new address[](2),msg.value,1,0)) - 1;
        games[id].players[0] = msg.sender;
        emit GameCreated(id,msg.value,games[id].players);
    }
    
    //anyone can join a game that is in gamestate=1 if they send the correct amount betSize. Gamecreator can't join his own game.
    function joinGame(uint _gameId) public payable createdNotStarted(_gameId){
        require((msg.sender)!=(games[_gameId].players[0]));
        require(msg.value==games[_gameId].betSize);
        games[_gameId].players[1]=msg.sender;
        totalAmount+=2*msg.value;
        games[_gameId].poolPayoutOffset=poolPayout;
        games[_gameId].gameState=2;
        emit GameStarted(_gameId,games[_gameId].betSize,games[_gameId].players);
    }
    
    //cancelGame first sets gameState to 0 if caller is game creator to prevent reentry. Then refunds betSize. 
    function cancelGame(uint _gameId) public createdNotStarted(_gameId){
        require( games[_gameId].players[0] == msg.sender);
        games[_gameId].gameState=0;
        msg.sender.transfer(games[_gameId].betSize);
        emit GameCanceled(_gameId,games[_gameId].betSize,games[_gameId].players);
    }
    
    //function called by a player who wishes to leave game. He takes back 85% of betSize + all accumulated payouts since game started. Other player takes back 110% of betSize + payouts. 5%of betSize awarded to all players, included these 2 proportionally to betSize
    function leaveGame(uint _gameId) public Playing(_gameId){
        address player1=games[_gameId].players[0];
        address player2=games[_gameId].players[1];
        uint localBetSize=games[_gameId].betSize;
        
        uint lostToPlayer=(localBetSize.mul(lostToPlayerPercent)).div(100);
        uint lostToPool=(localBetSize.mul(lostToPoolPercent)).div(100);
        uint lostToDev=(localBetSize.mul(devCutPercent)).div(100);
        
        // per player, makes sure you get payout from your pool from your own leave so as to not make advantageous to create multiple smaller games and leave them one by one.
        poolPayout+=((lostToPoolPercent.mul(localBetSize).mul(1 ether)).div(totalAmount)).div(100);
        uint wonFromPool=(localBetSize.mul(poolPayout.sub(games[_gameId].poolPayoutOffset)).div(1 ether));
        
        uint amountToLoser=localBetSize.sub(lostToPlayer+lostToPool+lostToDev)+wonFromPool;
        uint amountToWinner=localBetSize+lostToPlayer+wonFromPool;
  
        totalAmount=totalAmount.sub(2*localBetSize);
        games[_gameId].gameState=0;
        
        //Pay devCut on owner's account
        totalWinnings[owner]+=lostToDev;
        
        //msg.sender can only be player1 or player2 (checked by Playing() modifier)
        if(msg.sender==player1){
            totalWinnings[player1]+=amountToLoser;
            totalWinnings[player2]+=amountToWinner;                                       
        } else {
            totalWinnings[player2]+=amountToLoser;
            totalWinnings[player1]+=amountToWinner; 
        }

        emit GameFinished(_gameId,localBetSize,games[_gameId].players);
        
        //automatic withdraw for leaving player. Winning player will have to withdraw manually by calling the withdraw function himself.
        withdraw();
    }
    
    //anyone can call withdraw() to withdraw their total winnings. No partial withdrawals. transfer after updating totalWinnings to prevent reentry from being effective 
    function withdraw() public {
        uint amount=totalWinnings[msg.sender];
        totalWinnings[msg.sender]=0;
        msg.sender.transfer(amount);
        emit MoneyWithdrew(msg.sender,amount);
    }
    
    //debugging function to check game states
    function checkState(uint _gameId) external view returns(address[],uint,uint8,uint){
        return(games[_gameId].players,games[_gameId].betSize,games[_gameId].gameState,games[_gameId].poolPayoutOffset);
        }
    
    //GUI functions
    function totalNumberOfGames() external view returns(uint){
        return(games.length);
    }
    

}    

library SafeMath {
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }
 
  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }
 
  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b <= a);
    return a - b;
  }
 
  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}    
    
    
    
