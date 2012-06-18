$(document).ready(function () {
  var chat = io.connect('http://localhost:3000/chat')
  , $body = $('body')
  , $createRoom = $('#createRoom')
  , $content = $('#content')
  , $conversation = $('#conversation')
  , $data = $('#data')
  , $datasend = $('#datasend')
  , $label = $('#label')
  , $rooms = $('#rooms')
  , $roomname = $('#roomname')
  , $status = $('#status')
  , $users= $('#users');

  var username, currentroom;
  chat
  .on('connect', function(){
    username = prompt("What's your name?");
    chat.emit('adduser', username);
  })
  .on('updatechat', function (username, data) {
    $conversation.append('<b>'+username + ':</b> ' + data + '<br>');
  })
  .on('updateusers', function(data) {
    $users.empty();
    _.each(data, function(key) {
      $users.append('<p>' + key +'</p>');
    });
  })
  .on('error', function (data) {
    if (data && data.message) {
      $status.html(data.message);
    }
  })
  .on('roomcreated', function (name) {
    $label.html(name);
    currentroom = name;
    $conversation.empty();
    $conversation.append('You have just joined "' + name + '"');
  })
  .on('roomjoined', function (name) {
    currentroom = name;
    $conversation.empty();
    $conversation.append('You have just joined "' + name + '"');
  })
  .on('newguest', function (username) {
    $conversation.append('<b>'+username + '</b> just joined the room<br>');
  })
  .on('guestleaving', function (username) {
    $conversation.append('<b>'+username + '</b> just left the room<br>');
  })
  .on('updaterooms', function (rooms) {
    $rooms.empty();
    _.each(rooms, function(key) {
      $rooms.append('<a class="room" id="' + key + '">' + key + '</p>');
    });
  })
  .on('lobby', function (data) {
    $conversation.empty();
    $users.empty();
    _.each(data, function(key) {
      $users.append('<p>' + key + '</p>');
    });
  });

  $body.delegate('a.room', 'click', function (e) {
    var targetRoom = e.target.id;
    currentroom = targetRoom;
    chat.emit('leaveroom', currentroom);
    chat.emit('joinroom', targetRoom);
  });
  $body.delegate('#leaveRoom', 'click', function (e) {
    chat.emit('leaveroom', currentroom);
  });

  $createRoom.click(function () {
    var name = $roomname.val();
    $roomname.val('');
    chat.emit('createroom', name);
  });

  $(function(){
    $datasend.click( function() {
      var message = $data.val();
      $data.val('');
      chat.emit('sendchat', {
        room: currentroom,
        message: message
      });
    });
  });
});