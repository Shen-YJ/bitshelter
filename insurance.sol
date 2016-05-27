//Author Davide Carboni

contract Insurance {
	uint premium;
	address oracle;
	uint    compensation;
	address insurer;
	address subscriber;
	enum    state { CREATED, SUBSCRIBED, ACTIVE, CLAIMED, TERMINATED}
	state status;
	uint constant profit = 200 finney;
	uint duration;
	uint expireTime;
	event Subscription(address,uint);
	
	function Insurance(address anOracle,uint aPremium,uint comp, uint ttl) {
		oracle = anOracle;
		premium = aPremium;
		compensation = comp;
		duration = ttl;
        status = state.CREATED;
	}
	function subscribe() {
		
		if(status != state.CREATED) throw;
		
		Subscription(msg.sender,msg.value);
		if(msg.value==premium){
			subscriber=msg.sender;
			status = state.SUBSCRIBED;
		}
		else throw;
	}
	
	function back(){
		if(status != state.SUBSCRIBED) throw;
		
		if(msg.value==compensation){
			insurer=msg.sender;
			insurer.send(premium - profit);
			status = state.ACTIVE;
			expireTime = now + duration;
		}
		else throw;
	}
	


}
