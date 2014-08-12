var log4js = require("log4js");
var logger = log4js.getLogger("cryptchat");

exports.chat = function(req, res) {
  var ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
  logger.info("GET /chat from " + ip);
  res.render('chat', {host: req.protocol + "://" + req.header('host')});
};
