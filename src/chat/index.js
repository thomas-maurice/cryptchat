var log4js = require("log4js");
var logger = log4js.getLogger("cryptchat");
var sugar = require("sugar");

var sockets = []

module.exports.onConnection = function(socket){
    logger.debug("WS " + socket.id + " connected");
    sockets.add(socket);
    logger.debug("Now " + sockets.length + " clients connected")
    socket.emit("connected");
    socket.emit('contactid', socket.id);
    socket.on('disconnect', function() {
        logger.debug("WS " + socket.id + " disconnected");
        sockets.remove(function(el) { return el.id === socket.id; });
    })
    
    // Binds !
    socket.on('chatrequest', function(request) {
        logger.trace("REQT " + request.source + " -> " + request.dest);
        var target = sockets.filter(function(s) {return s.id == request.dest;})

        if(target.length == 0) {
            logger.error(request.dest + " does not exist !");
            return;
        } else {
            target = target[0]
            target.emit('chatrequest', request);
        }
    });
    
    socket.on('chatresponse', function(request) {
        logger.trace("RESP " + request.source + " -> " + request.dest);
        var target = sockets.filter(function(s) {return s.id == request.dest;})
        
        if(target.length == 0) {
            logger.error(request.dest + " does not exist !");
            return;
        } else {
            target = target[0]
            target.emit('chatresponse', request);
        }
    });
    
    socket.on('message', function(request) {
        logger.trace("MSG  " + request.source + " -> " + request.dest);
        var target = sockets.filter(function(s) {return s.id == request.dest;})
        
        if(target.length == 0) {
            logger.error(request.dest + " does not exist !");
            return;
        } else {
            target = target[0]
            target.emit('message', request);
            console.log(request)
        }
    });
}
