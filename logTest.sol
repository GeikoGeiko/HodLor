pragma solidity ^0.4.0;
contract logTest {


    function getShare(uint _Meps) public pure returns(uint Mshare){
        return(1000000000-(1000000000-_Meps)*getLn(1000000000*1000000000/(1000000000-_Meps))/_Meps);
    }

    function getLn(uint _input) public pure returns(uint) {
        require(_input>=1000000000);
        uint x=_input;
        uint log=0;
      
        while(x>=1500000000){
            log+=405465108;
            x=x*2/3;
        }
        
        x-=1000000000;
        
        uint y=x;
        uint i=1;
        
        while(i<10){
            log+=y/i;
            i+=1;
            y=y*x/1000000000;
            log-=y/i;
            i+=1;
            y=y*x/1000000000;
        }
        
        return(log);
        
    }
    
}
    
