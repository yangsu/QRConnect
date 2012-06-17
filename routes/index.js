
/*
 * GET home page.
 */

exports.index = function(req, res){
  res.render('index', {
    title: 'Express',
    scripts: [
      'javascripts/libs/socket.io.js',
      'javascripts/script.js'
    ]
  })
};