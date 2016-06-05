contract('Insurance', function(accounts) {
  it("should create insurance with state CREATED", function(done) {
    var ins = Insurance.deployed();
    ins.getState.call().then(function(state) {
      console.log(state);
      assert(state,0,"incorrect state");
    }).then(done);
  });


});
