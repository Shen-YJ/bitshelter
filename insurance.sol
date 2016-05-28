//Author Davide Carboni

contract Insurance {
	uint premium;
	address oracle=0;
	uint    compensation=0;
	address insurer=0;
	address subscriber=0;
	uint    state=0; 
	uint CREATED=1; 
	uint SUBSCRIBED=2;
	uint ACTIVE=3;
	uint CLAIMED=4;
	uint TERMINATED=5;
	
	uint constant profit = 200 finney;
	uint duration;
	uint expireTime;
	event Subscription(address,uint);
	
	function Insurance(address anOracle,uint aPremium,uint comp, uint ttl) {
		
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
	


}
