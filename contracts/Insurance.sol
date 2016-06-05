//A basic learning-by-doing insurance contract in Solidity
//Author Davide "dada" Carboni
//Licensed under MIT

contract Insurance {

	//premium is what you pay to subscribe the policy
	uint    premium;

	//oracle is the 3rp party in charge of stating if a claim is legit
	address oracle;

	//protection is the financial protection provided by the contract
	uint    protection;

	//insurer is the one who locks his money to fund the protection
	address insurer;

	//subscriber is who wants the insurance protection
	address subscriber;

	//contractCreator is who deploys the contract for profit
	address contractCreator;

	//the contract goes throught many states
	uint      state;
	uint      CREATED=0;
	uint			VALID=1;
	uint			SUBSCRIBED=2;
	uint			ACTIVE=3;
	uint			CLAIMED=4;
	uint			EXPIRED=5;
	uint			PAID=6;
	uint		  REJECTED=7;

	//let's assign a fixed profit to who created the contract
	uint constant profit = 200 finney;

	//duration, a contract cannot last for ever
	uint duration;

	//expireTime is when the contract expires
	uint expireTime;

	function Insurance(){
		// this function use no args because of Truffle limitation
		contractCreator = msg.sender;
		state = CREATED;

	}


	function init(address anOracle,uint aPremium,uint prot, uint ttl) {


		if(state!=CREATED) throw;

		oracle = anOracle;
		premium = aPremium * 1 ether;
		protection = prot * 1 ether;
		duration = ttl;

		bool valid;
		//let's check all the var are set
		valid = oracle !=0 && premium !=0 && protection!=0 && duration!=0;
		if (!valid) throw;
        state = VALID;
	}


	function subscribe() {
		//is in the proper state?
		if(state != VALID) throw;

		//can't be both subscriber and oracle
		if(msg.sender == oracle) throw;

		//must pay the exact sum
		if(msg.value==premium){
			subscriber=msg.sender;
			state = SUBSCRIBED;

			//the contract creator grabs his money
			contractCreator.send(profit);
		}
		else throw;
	}

	function back(){
	    //check proper state
		if(state != SUBSCRIBED) throw;

		//can't be both backer and oracle
		if(msg.sender == oracle) throw;

		//must lock the exact sum for protection
		if(msg.value==protection){
			insurer=msg.sender;

			//insurer gets his net gain
			insurer.send(premium - profit);
			state = ACTIVE;
			expireTime = now + duration;
		}
		else throw;
	}

	function claim(){
		//if expired unlock sum to insurer and destroy contract
		if(now > expireTime){
			state = EXPIRED;
			insurer.send(protection);
			selfdestruct(contractCreator);
		}

		//check if state is ACTIVE
		if(state!=ACTIVE)throw;

		//are you the subscriber?
		if(msg.sender != subscriber)throw;

		//ok, claim registered
		state=CLAIMED;
	}

	function oracleDeclareClaim(bool isTrue){

		//is claimed?
		if(state != CLAIMED)throw;

		//are you the oracle?
		if(msg.sender!=oracle)throw;

		//if claim is legit then send money to subscriber
		if(isTrue){
			subscriber.send(protection);
			state = PAID;
		}else{
			state = REJECTED;
			insurer.send(protection);

		}

		//in any case destroy the contract and change is back to creator
		selfdestruct(contractCreator);
	}

	function getState() returns(uint){
		return state;
	}




}
