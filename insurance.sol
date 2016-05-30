//A simple learn how to do insurance contract in Solidity
//Author Davide "dada" Carboni
//Licensed under MIT

contract Insurance {
	uint premium;
	address oracle;
	uint    compensation;
	address insurer;
	address subscriber;
	address contractCreator;
		
	uint state=0; 
	uint CREATED=1; 
	uint SUBSCRIBED=2;
	uint ACTIVE=3;
	uint CLAIMED=4;
	uint EXPIRED=5;
	uint PAID=6;
	uint REJECTED=7;
	
	uint constant profit = 200 finney;
	uint duration;
	uint expireTime;
	event Subscription(address,uint);
	
	function Insurance(address anOracle,uint aPremium,uint comp, uint ttl) {
		contractCreator = msg.sender;
		oracle = anOracle;
		premium = aPremium * 1 ether;
		compensation = comp * 1 ether;
		duration = ttl;
		bool valid;
		valid = oracle !=0 && premium !=0 && compensation!=0 && duration!=0;
		if (!valid) throw;
        state = CREATED;
	}
	function subscribe() {
		
		if(state != CREATED) throw;
		if(msg.sender == oracle) throw;//can't be both subscriber and oracle
		
		Subscription(msg.sender,msg.value);
		if(msg.value==premium){
			subscriber=msg.sender;
			state = SUBSCRIBED;
		}
		else throw;
	}
	
	function back(){
		if(state != SUBSCRIBED) throw;
		if(msg.sender == oracle) throw;//can't be both backer and oracle

		if(msg.value==compensation){
			insurer=msg.sender;
			insurer.send(premium - profit);
			state = ACTIVE;
			expireTime = now + duration;
		}
		else throw;
	}
	
	function claim(){
		if(now > expireTime){
			state = EXPIRED;
			insurer.send(compensation);
			selfdestruct(contractCreator);
		}
		if(state!=ACTIVE)throw;
		if(msg.sender != subscriber)throw;
		state=CLAIMED;
	}
	
	function oracleDeclareClaim(bool isTrue){
		if(state != CLAIMED)throw;
		if(msg.sender!=oracle)throw;
		if(isTrue){
			subscriber.send(compensation);
			state = PAID;
		}else{
			state = REJECTED;
			insurer.send(compensation);
			
		}
		selfdestruct(contractCreator);
	}
	
	
	
	


}
