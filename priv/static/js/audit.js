
var $messages = $("#messages");


var socket = new Phoenix.Socket("/ws")
socket.connect()
socket.join("audit:all").receive("ok", function(chan){
    console.log("Connected to WS")
    chan.on("new:message", function(msg){
        console.log(msg)
        $messages.append("<br/>" + msg.id + " ->"  + msg.success + " - " + msg.behaviour)
    });
})
