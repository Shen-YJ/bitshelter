
insured = web3.eth.accounts[0]
insurer = web3.eth.accounts[1]
oracle  = web3.eth.accounts[2]

contract('Insurance', function(accounts) {
  it("should create insurance with state CREATED", function(done) {
    var ins = Insurance.deployed();
    ins.getState.call().then(function(state) {
      console.log(state);
      assert(state,0,"incorrect state");
    }).then(done);
  });

  it("should init insurance with state VALID", function(done) {
    var ins = Insurance.deployed();
    ins.init(oracle,1,100,10).then(
      function(tx){
        console.log("ciao!!!"+tx);
        ins.getState.call().then(
          function(state){
            console.log(state);
            assert(state,1,"incorrect state");
          }
        ).then(done);

      });
  });

});