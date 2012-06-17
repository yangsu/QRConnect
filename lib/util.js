function randomGenerator(length, charset) {
  // Set default params (32 char, alphanumeric charset)
  length = (typeof length !== "undefined") ? length : 32;
  charset = (typeof charset !== "undefined") ? charset : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

  var rndstr = "";

  for (var i=0; i < length; ++i) {
    rndstr += charset[Math.floor(Math.random()*charset.length)];
  }

  return rndstr;
}

exports.randomGenerator = randomGenerator;
