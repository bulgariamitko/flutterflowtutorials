// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=zVc4UuIT6Gk
// support my work - https://github.com/sponsors/bulgariamitko

const functions = require("firebase-functions");

exports.helloWorld = functions.https.onRequest((request, response) => {
	response.send("Hello from Firebase!");
});