// constructor
// form holds the bid for each value
var AuctionSocket = function(user_id, auction_id, form) {
  this.user_id = user_id;
  this.auction_id = auction_id;
  this.form = $(form);

  // App.websocket_url 
  this.socket = new WebSocket(App.websocket_url + "auctions/" + this.auction_id);

  this.initBinds();
};

AuctionSocket.prototype.initBinds = function() {
  var _this = this;
  // pick up on the form and register a callback to the submit event
  this.form.submit(function(e) {
    // prevent the form from being submitted and submitted out the standard application
    e.preventDefault();
    // pass in the value that will go into the text field
    _this.sendBid($("#bid_value").val());
  }); 
  this.socket.onmessage = function(e) {
    // interpretation from the events of the server
    // 5 messages being sent from the server
    // bidok
    // underbid
    // outbid
    // won
    // lost

    // property inside the event is a string, convert to array 
    var tokens = e.data.split(" ");

    switch(tokens[0]) {
      case "bidok":
        _this.bid(tokens[1]);
        break;
      case "underbid":
        _this.underbid(tokens[1]);
        break;
      case "outbid":
        _this.outbid(tokens[1]);
        break;
      case "won":
        _this.won();
        break;
      case "lost":
        _this.lost();
        break;
    }
    // log the message so that we can see what message we got from the server
    console.log(e);
  };
};

// method sends bid to socket and nothing else
AuctionSocket.prototype.sendBid = function(value) {
  this.value = value;
  var template = "bid {{auction_id}} {{user_id}} {{value}}";
  // sends msg to socket server
  // bid user_id auction_id value
  this.socket.send(Mustache.render(template, {
    user_id: this.user_id,
    auction_id: this.auction_id,
    value: value
  }));
};

// bidok
AuctionSocket.prototype.bid = function() {
  this.form.find(".message strong").html(
    "Your bid: " + this.value  
  );
};

// outbid value
AuctionSocket.prototype.outbid = function(value) {
  this.form.find(".message strong").html(
    "You were outbidded. It is now " + value + "."
  );
};

// underbid
AuctionSocket.prototype.underbid = function(value) {
  this.form.find(".message strong").html(
    "Your bid is under " + value + "."
  );
};

// won
AuctionSocket.prototype.won = function() {
  this.form.find(".message strong").html(
    "You won! " + this.value
  );
};

// lost
AuctionSocket.prototype.lost = function() {
  this.form.find(".message strong").html("You lost the auction.");
};