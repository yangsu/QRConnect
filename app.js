
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
var users = {};
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
      if (users[username]) {
        socket.emit('error', { message: 'Username already exists' });
      } else {
        // Set socket username
        socket.username = username;
        // Added it to users with timestamp
        users[username] = {
          connected: new Date()
        };

        socket
          .join('lobby')
          // Return status
          .emit('updatechat', 'SERVER', 'you have connected')
          // Send list of rooms available
          .emit('updaterooms', _.keys(rooms));

        // Send everyone updated users list
        chat.in('lobby').emit('updateusers', _.keys(users));
      }
    })
    .on('createroom', function (name) {
      if (name && rooms[name]) {
        socket.emit('error', {
          message: 'room "' + name + '" already exists'
        });
      } else {
        // create room with name and add the current user to the list of clients
        rooms[name] = [ socket.username ];
        socket.join(name);

        chat.emit('updaterooms', _.keys(rooms))
        socket
          .emit('roomcreated', name)
          .emit('updateusers', rooms[name]);
      }
    })
    .on('joinroom', function (name) {
      if (name && rooms[name]) {
        if (_.contains(rooms[name], socket.username)) {
          socket.emit('error', {
            message: 'You are already in this room'
          });
        } else {
          // add user to the room
          rooms[name].push(socket.username);
          socket.join(name);

          socket.emit('roomjoined', name);

          chat.in(name)
            .emit('newguest', socket.username)
            .emit('updateusers', rooms[name]);
        }
      } else {
        socket.emit('error', {
          message: '"' + name + '" doesn\'t exist'
        });
      }
    })
    .on('leaveroom', function (name) {
      if (name && rooms[name]) {
        socket.leave(name);
        rooms[name] = _.without(rooms[name], socket.username);
        // if no one's in the room. destroy it
        if (rooms[name].length === 0) {
          delete rooms[name];
          chat.emit('updaterooms', _.keys(rooms));
        }

        chat.in(name)
          .emit('guestleaving', socket.username)
          .emit('updateusers', rooms[name]);
        // return user to labby
        socket.emit('lobby', _.keys(users));
      }
    })
    .on('disconnect', function(){
      delete users[socket.username];
      _.each(rooms, function (userlist, roomname) {
        rooms[roomname] = _.without(userlist, socket.username);
      });
      socket.broadcast
        .emit('updateusers', _.keys(users))
        .emit('updatechat', 'SERVER', socket.username + ' has disconnected');
    });
});