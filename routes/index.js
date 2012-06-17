
/*
 * GET home page.
 */

exports.index = function(req, res){
  res.render('index', { title: 'Express' });
};

exports.getToken = function(req, res){
  var util = require('../lib/util');
  res.json({token: util.randomGenerator()});
};
