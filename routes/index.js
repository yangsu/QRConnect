
/*
 * GET home page.
 */

exports.index = function(req, res){
  res.render('index', {
    title: 'Express',
    scripts: [
      'javascripts/libs/socket.io.js',
      'javascripts/libs/jquery-1.7.2.js',
      'javascripts/script.js'
    ]
  })
};

exports.getToken = function(req, res){
  var util = require('../lib/util');
  res.json({token: util.randomGenerator()});
};
