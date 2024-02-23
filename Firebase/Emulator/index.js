// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=aBC7A2oFsdM
// replace - [{"Name of json auth file": "auth.json"}, {"Firebase project ID": "project-id"}]
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const moment = require('moment');
const cronParser = require('cron-parser');
const cron = require('cron');
const { CronJob } = cron;

const serviceAccount = require('./auth.json');
const app = admin.initializeApp({
  projectId: 'project-id',
  credential: admin.credential.cert(serviceAccount),
});

app.firestore().settings({
  host: 'localhost:8080',
  ssl: false,
});

const now = new Date();
console.log(`Function checkAndSendNotifications loaded at ${now}`);
const checkAndSendNotifications = new CronJob('* * * * *', async function () {
  console.log('Function checkAndSendNotifications running');
  const notificationsRef = admin.firestore().collection('notifications');
  const currentTime = moment.utc().format('m H D M d');
  const currentTimeArray = currentTime.split(' ');

  const snapshot = await notificationsRef.get();

  console.log(['snapshot', snapshot.size]);

  snapshot.forEach(async (doc) => {
    const { serverCron, userRef, title, desc } = doc.data();
    const serverCronArray = serverCron.split(' ');

    // Check if current time matches serverCron
    const interval = cronParser.parseExpression(serverCron, { utc: true });
    const previousDate = interval.prev().toDate();
    const nextDate = interval.next().toDate();
    const currentTime = moment.utc();
    const isMatch = currentTime.isBetween(previousDate, nextDate);

    console.log(`serverCron: ${serverCron}`);
    console.log(`current time cron: ${currentTime}`);
    console.log(`isMatch: ${isMatch}`);

    if (isMatch) {
      // Check if userRef is a DocumentReference object
      console.log(['userRef', userRef instanceof admin.firestore.DocumentReference]);
      if (userRef instanceof admin.firestore.DocumentReference) {
        const fcmTokensSnapshot = await userRef.collection('fcm_tokens').get();

        fcmTokensSnapshot.forEach(async (tokenDoc) => {
          const tokenData = tokenDoc.data();

          // Send push notification to the user using Firebase Messaging
          console.log(['tokenData', tokenData, tokenData.fcm_token]);
          if (tokenData && tokenData.fcm_token) {
            const message = {
              token: tokenData.fcm_token,
              notification: {
                title: title,
                body: desc,
              },
            };

            try {
              const response = await admin.messaging().send(message);
              console.log('Successfully sent message:', response);
            } catch (error) {
              console.error('Error sending message:', error);
            }
          }
        });
      }
    }
  });
}, null, true, 'UTC');

exports.checkAndSendNotifications = functions.pubsub.schedule('* * * * *').onRun((context) => {
  checkAndSendNotifications.start();
});

exports.triggerCheckAndSendNotifications = async function() {
  await checkAndSendNotifications.start();
};