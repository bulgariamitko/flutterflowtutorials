// YouTube channel - https://www.youtube.com/@dimitarklaturov
// paid video - https://www.youtube.com/watch?v=I5zMJDnJpEU
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

const functions = require('firebase-functions');
const admin = require('firebase-admin');
// To avoid deployment errors, do not call admin.initializeApp() in your code
const cors = require('cors')({ origin: true });

exports.fixCorsError = functions.https.onRequest((data, res) => {
    cors(data, res, async () => {
        const userId = req.body.userId || (req.body.data && req.body.data.userId);
        const authUserId = req.body.authUserId || (req.body.data && req.body.data.authUserId);


        // add your code here
    });
});