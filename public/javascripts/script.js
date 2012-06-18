var chat = io.connect('http://localhost:3000/chat');
chat
.on('connect', function(){
  chat.emit('adduser', prompt("What's your name?"));
})
.on('updatechat', function (username, data) {
  $('#conversation').append('<b>'+username + ':</b> ' + data + '<br>');
})
.on('updateusers', function(data) {
  $('#users').empty();
  $.each(data, function(key, value) {
    $('#users').append('<div>' + key + '</div>');
  });
});

$(function(){
  $('#datasend').click( function() {
    var message = $('#data').val();
    $('#data').val('');
    chat.emit('sendchat', message);
  });

  $('#data').keypress(function(e) {
    if(e.which == 13) {
      $(this).blur();
      $('#datasend').focus().click();
    }
  });
});