/*
 * chatjs.js 
 * ---------
 * 
 * Author: svartbergtroll <tmaurice59@gmail.com>
 * Web: https://github.com/svartbergtroll/chatjs
 * 
 * Simple chat app
 */

/* Load the required frameworks */
var express = require("express");
var log4js = require("log4js");
var swig = require("swig");
var bodyparser = require('body-parser');
var http = require('http');
var fs = require('fs');
var socketio = require('socket.io');

if(!fs.existsSync('./logs')) {
    fs.mkdir('./logs')
}

/* Configure the logger */
log4js.configure('conf/log4js.json', {});
var logger = log4js.getLogger("cryptchat");
logger.info("Loading cryptchat v0.0.1...")

var conf = require("./conf/cryptchat.json");
logger.trace("Configured to run on port " + conf.port);

/* Load the routes */
var routes  = require("./routes");
/* Load the chat logic */
//var chat = require("./chat");

var app = express();

/* Configure Express */
app.engine('html', swig.renderFile);
app.set('views', __dirname + '/views');
app.set('view engine', 'html');
app.use(express.static(__dirname + '/public'));
app.use(bodyparser.urlencoded({extended: true}));

/* Map stuff */
app.get('/', routes.index);
app.get('/chat', routes.chat);

var server = http.createServer(app);

/* Launch the server */
server.listen(conf.port, '0.0.0.0', logger.info("Server up and ready, listens on http://0.0.0.0:"+conf.port));
var io = socketio.listen(server);

/* Bind the socketio callbacks */
io.sockets.on('connection', function(socket){
    logger.debug('New websocket ' + socket.id);
    socket.emit('contactid', socket.id);
    socket.emit("connected");
    socket.on('disconnect', function() {logger.debug(socket.id + " disconnected");})
});
