//Author Davide Carboni

contract Insurance {
	uint premium;
	address oracle;
	uint    liability;
	address insurer;
	address subscriber;
	event Subscription(address,uint);
	
	function Insurance(address o,uint p,uint l) {
		oracle = o;
		premium = p;
		liability = l;

	}
	function subscribe() {
		Subscription(msg.sender,msg.value);
		if(msg.value==premium){
			subscriber=msg.sender;
			
		}
		else throw;
	}
	
	function back(){
		if(msg.value==liability){
			insurer=msg.sender;
			insurer.send(premium);
		}
		else throw;
	}
	
	function oracleSays(bool verdict){
		if (msg.sender != oracle) throw;
		
		if(verdict){
			subscriber.send(liability);
		}
		else{
			insurer.send(liability);
		}
	}

}
