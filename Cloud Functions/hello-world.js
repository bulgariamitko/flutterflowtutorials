// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=zVc4UuIT6Gk
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

const functions = require("firebase-functions");

exports.helloWorld = functions.https.onRequest((request, response) => {
	response.send("Hello from Firebase!");
});