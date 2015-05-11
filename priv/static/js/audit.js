
var $messages = $("#messages");
var socket = new Phoenix.Socket("/ws")
var chan = socket.chan("audit:all", {});
console.log("Connected to channel");

chan.on("*", function(msg){
    console.log(msg)
    $messages.append("<br/>" + msg.id + " ->"  + msg.success + " - " + msg.behaviour)
});
