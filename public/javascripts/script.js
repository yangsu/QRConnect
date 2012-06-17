var chat = io.connect('http://localhost/chat')
  , connect = io.connect('http://localhost/connect')

chat.on('a message', function (data) {
  console.log(data);
  chat.emit('hi!');
});

connect.on('success', function (data) {
  console.log(data);
  connect.emit('woot');
});