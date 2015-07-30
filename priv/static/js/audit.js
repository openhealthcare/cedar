
var $messages = $("#messages");


var socket = new Phoenix.Socket("/ws");
socket.connect();
socket.onClose( function(e) {console.log("CLOSE", e)})

var chan = socket.chan("audit:all", {});

chan.on("new:message", function(msg){
    console.log(msg);
    $messages.append("<br/>" + msg.id + " ->"  + msg.success + " - " + msg.behaviour);
});

chan.join().receive("ok", function(c){
    console.log("Connected to WS");
});



