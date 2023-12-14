// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=nC_Re2seyxs
// replace - [{"File name": "auth.json"}]
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const moment = require('moment');
const cron = require('cron');
const { CronJob } = cron;

function doCronExpressionsMatch(cronExpression, currentTime) {
  const cronFields = cronExpression.split(' ');
  const currentMoment = moment(currentTime);

  const minuteMatch = cronFields[0] === '*' || parseInt(cronFields[0]) === currentMoment.minutes();
  const hourMatch = cronFields[1] === '*' || parseInt(cronFields[1]) === currentMoment.hours();

  return minuteMatch && hourMatch;
}
async function checkNotifications() {
  const notificationsRef = admin.firestore().collection('notifications');
  const currentTime = moment.utc();
  const snapshot = await notificationsRef.get();

  for (let i = 0; i < snapshot.docs.length; i++) {
    const doc = snapshot.docs[i];
    const { serverCron, userRef, title, desc, lastSend } = doc.data();

    const isMatch = doCronExpressionsMatch(serverCron, currentTime);

    if (isMatch) {
      // Check if a notification was already sent in the same minute
      let lastSendMoment;
      if (lastSend) {
        lastSendMoment = moment(lastSend.toDate());
      }

      if (lastSendMoment && currentTime.diff(lastSendMoment, 'minutes') < 1) {
        continue;
      }

      if (userRef instanceof admin.firestore.DocumentReference) {
        const fcmTokensSnapshot = await userRef.collection('fcm_tokens').orderBy('created_at', 'desc').limit(1).get();

        fcmTokensSnapshot.forEach(async (tokenDoc) => {
          const tokenData = tokenDoc.data();

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

              // Update lastSend in Firestore
              await doc.ref.update({ lastSend: admin.firestore.Timestamp.fromDate(currentTime.toDate()) });

            } catch (error) {
              console.error('Error sending message:', error);
            }
          }
        });
      }
    }
  }
}

exports.sendScheduledNotification = functions.pubsub.schedule('every 10 minutes').onRun(async (context) => {
   await checkNotifications();
});