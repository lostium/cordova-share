//
// SocialShare.js
//
// Created by Lostium Project on  2013-10-22.

var cordova = require('cordova'),
    exec = require('cordova/exec');

var SocialShare = function() {
};

// Call this to register for push notifications and retreive a deviceToken
SocialShare.prototype.share = function(options, success, error) {
  //cordova.exec(success, error, "BundleIdentifier", "get", options ? [options] : []);
};

var socialShare = new SocialShare();
module.exports = socialShare;
