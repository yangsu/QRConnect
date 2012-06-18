
/**
 * Module dependencies.
 */

var _ = require('underscore')
  , express = require('express')
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
var rooms = {};
var chat = io.of('/chat');
chat
.on('connection', function (socket) {
  socket
    .on('sendchat', function (data) {
      if (data && data.room && data.message && rooms[data.room]) {
        chat.in(data.room).emit('updatechat', socket.username, data.message);
      }
    })
    .on('adduser', function(username){
      socket.username = username;
      usernames[username] = username;
      socket.emit('updatechat', 'SERVER', 'you have connected');
      // socket.broadcast.emit('updatechat', 'SERVER', username + ' has connected');
      chat.emit('updateusers', _.keys(usernames));
      socket.emit('updaterooms', _.keys(rooms));
      console.log(_.keys(usernames));
      console.log(_.keys(rooms));
    })
    .on('createroom', function (name) {
      if (name && rooms[name]) {
        socket.emit('error', {
          message: '"' + name + '" already exists'
        });
      } else {
        rooms[name] = [ socket.username ];
        socket.emit('roomcreated', name);
        socket.join(name);
        console.log(socket.username + ' joined ' + name);
        chat.emit('updaterooms', _.keys(rooms));
        chat.emit('updateusers', rooms[name]);
      }
    })
    .on('joinroom', function (name) {
      console.log(rooms);
      if (name && rooms[name]) {
        if (!_.contains(rooms[name], socket.username)) {
          rooms[name].push(socket.username);
          socket.join(name);
          socket.emit('roomjoined', name);
          chat.in(name).emit('newguest', socket.username);
          chat.in(name).emit('updateusers', rooms[name]);
        } else {
          socket.emit('error', {
            message: 'You are already in this room'
          });
        }
      } else {
        socket.emit('error', {
          message: '"' + name + '" doesn\'t exist'
        });
      }
    })
    .on('leaveroom', function (name) {
      if (name && rooms[name]) {
        rooms[name] = _.without(rooms[name], socket.username);
        if (!rooms[name].length) {
          delete rooms[name];
          chat.emit('updaterooms', _.keys(rooms));
        }
        socket.leave(name);
        chat.in(name).emit('guestleaving', socket.username);
        chat.in(name).emit('updateusers', rooms[name]);
        socket.emit('lobby', _.keys(usernames));
      }
    })
    .on('disconnect', function(){
      delete usernames[socket.username];
      socket.broadcast.emit('updateusers', _.keys(usernames));
      socket.broadcast.emit('updatechat', 'SERVER', socket.username + ' has disconnected');
    });
});

var connect = io
  .of('/connect')
  .on('connection', function (socket) {
    socket.emit('success', { msg: 'true' });
  });
