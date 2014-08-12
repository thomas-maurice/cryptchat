var log4js = require("log4js");
var logger = log4js.getLogger("cryptchat");

exports.index = function(req, res) {
  var ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
  logger.info("GET / from " + ip);
  res.render('index',  {host: req.protocol + "://" + req.header('host')});
}

exports.chat = require("./chat.js").chat;
