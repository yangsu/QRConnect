
/**
 * Module dependencies.
 */

var express = require('express')
  , stylus = require('stylus')
  , routes = require('./routes')
  , app = module.exports = express.createServer()
  , io = require('socket.io').listen(app);

// Configuration
app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(stylus.middleware({
    src: __dirname + '/views',
    dest: __dirname + '/public'
  }));
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('production', function(){
  app.use(express.errorHandler());
});

// Routes

app.get('/', routes.index);

app.get('/token', routes.getToken);

app.listen(3000, function(){
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});

// Socket.io
var usernames = {};
var chat = io.of('/chat');
chat
.on('connection', function (socket) {
  socket
    .on('sendchat', function (data) {
      chat.emit('updatechat', socket.username, data);
    })
    .on('adduser', function(username){
      socket.username = username;
      usernames[username] = username;
      socket.emit('updatechat', 'SERVER', 'you have connected');
      socket.broadcast.emit('updatechat', 'SERVER', username + ' has connected');
      chat.emit('updateusers', usernames);
    })
    .on('disconnect', function(){
      delete usernames[socket.username];
      socket.broadcast.emit('updateusers', usernames);
      socket.broadcast.emit('updatechat', 'SERVER', socket.username + ' has disconnected');
    });
});

var connect = io
  .of('/connect')
  .on('connection', function (socket) {
    socket.emit('success', { msg: 'true' });
  });
