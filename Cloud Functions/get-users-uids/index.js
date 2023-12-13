// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

const functions = require('firebase-functions');
const admin = require('firebase-admin');

exports.getUserUIDs = functions.https.onRequest(async (request, response) => {
  try {
    const allUserUIDs = [];
    let nextPageToken;

    do {
      const listUsersResult = await admin.auth().listUsers(1000, nextPageToken);

      listUsersResult.users.forEach((userRecord) => {
        allUserUIDs.push(userRecord.uid);
      });

      nextPageToken = listUsersResult.pageToken;
    } while (nextPageToken);

    response.status(200).send(allUserUIDs);
  } catch (error) {
    console.error('Error fetching user data:', error);
    response.status(500).send('Error fetching user data');
  }
});
