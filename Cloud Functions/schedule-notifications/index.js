// code created by https://www.youtube.com/@flutterflowexpert
// future video - https://www.youtube.com/watch?v=nC_Re2seyxs
// replace - [{"File name": "auth.json"}]
// support my work - https://github.com/sponsors/bulgariamitko

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const moment = require('moment');
const cronParser = require('cron-parser');
const cron = require('cron');
const { CronJob } = cron;

const serviceAccount = require('./auth.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// PART 1 - test push notifications
exports.sendNotification = functions.https.onRequest(async (req, res) => {
  // Extract userId, title, and desc from the request's URL
  const userId = req.query.userId;
  const title = req.query.title;
  const desc = req.query.desc;

  // Validate the parameters
  if (!userId || !title || !desc) {
    res.status(400).send('Missing required parameters.');
    return;
  }

  // Fetch the user's FCM token
  const fcmTokensSnapshot = await admin
    .firestore()
    .collection('users')
    .doc(userId)
    .collection('fcm_tokens')
    .get();

  if (fcmTokensSnapshot.empty) {
    res.status(404).send('User not found or FCM token not available.');
    return;
  }

  // Get the list of FCM tokens
  const fcmTokens = fcmTokensSnapshot.docs.map((doc) => doc.data().fcm_token);

  // Send a notification
  const payload = {
    notification: {
      title: title,
      body: desc,
    },
  };

  await admin.messaging().sendToDevice(fcmTokens, payload);
  res.status(200).send('Notification sent successfully.');
});

// https://us-central1-[PROJECT-ID].cloudfunctions.net/sendNotification?userId=[USERID]&title=demo&desc=my.desc
// http://127.0.0.1:5001/[PROJECT-ID]/us-central1/sendNotification?userId=[USERID]&title=demo&desc=my.desc


// PART 2 - convert user time to server time
function adjustCronField(field, adjustment, unit) {
  if (field === '*' || field.includes('-')) {
    return field;
  }

  const separator = field.includes(',') ? ',' : field.includes('/') ? '/' : '';

  if (separator) {
    const parts = field.split(separator).map((part, index) => {
      // If it's a step value (using '/'), adjust only the base value
      if (separator === '/' && index === 1) {
        return part;
      }

      const value = parseInt(part, 10);
      const adjustedValue = moment().set(unit, value).add(adjustment, unit).get(unit);
      return index === 0 && separator === '/' ? adjustedValue + separator + part : adjustedValue;
    });

    return parts.join(separator === ',' ? separator : '');
  }

  const value = parseInt(field, 10);
  return moment().set(unit, value).add(adjustment, unit).get(unit);
}

function calculateServerCron(localCron, localUserTime, timeDifference) {
  const localCronFields = localCron.split(' ');

  const localNext = cronParser.parseExpression(localCron).next().toDate();
  const serverNext = moment(localNext).add(timeDifference, 'minutes').toDate();

  // Use the "serverNext" variable to adjust each cron field individually
  localCronFields[0] = adjustCronField(localCronFields[0], serverNext.getMinutes() - localNext.getMinutes(), 'minute');
  localCronFields[1] = adjustCronField(localCronFields[1], serverNext.getHours() - localNext.getHours(), 'hour');

  const serverCron = localCronFields.join(' ');

  return serverCron;
}

exports.calculateServerTime = functions.firestore
  .document('notifications/{notificationId}')
  .onWrite(async (change, context) => {
    const { notificationId } = context.params;
    const newData = change.after.data();
    const previousData = change.before.data();

    // Check if localCron or localUserTime have been created or updated
    if (
      !previousData ||
      newData.localCron !== previousData.localCron ||
      newData.localUserTime !== previousData.localUserTime
    ) {
      // Ensure the necessary properties are present
      if (!newData.localCron || !newData.localUserTime) {
        return;
      }

      const { localUserTime, localCron, title, desc } = newData;

      // Calculate the difference between the local user's time and the server time (in minutes)
      const localUserMoment = moment(localUserTime);
      const serverMoment = moment.utc();
      let timeDifference = serverMoment.diff(localUserMoment, 'minutes');

      // Round the timeDifference to the nearest 30 minutes
      timeDifference = Math.round(timeDifference / 30) * 30;

      // Calculate the server cron using the provided function
      const serverCron = calculateServerCron(localCron, localUserTime, timeDifference);

      // Update the document with serverTime, serverCron, and timeDiff
      await admin
        .firestore()
        .collection('notifications')
        .doc(notificationId)
        .update({
          serverTime: serverMoment.format(),
          serverCron: serverCron,
          timeDiff: timeDifference,
          title: title,
          desc: desc,
        });
    }
});


// PART 3 - check every min for serverCron and if it is true send the notification
function doCronExpressionsMatch(cron1, currentTime) {
  const cron1NextRun = cronParser.parseExpression(cron1).next().toDate();

  // Round down the milliseconds of both the cron1NextRun and currentTime to the nearest minute
  const roundedCron1NextRun = new Date(Math.floor(cron1NextRun.getTime() / 60000) * 60000);
  const roundedCurrentTime = new Date(Math.floor(currentTime.getTime() / 60000) * 60000);

  return roundedCron1NextRun.getTime() === roundedCurrentTime.getTime();
}

const checkAndSendNotifications = new CronJob('* * * * *', async function () {
  const notificationsRef = admin.firestore().collection('notifications');
  const currentTime = moment.utc();
  const snapshot = await notificationsRef.get();


  snapshot.forEach(async (doc) => {
    const { serverCron, userRef, title, desc } = doc.data();

    // Check if current time matches serverCron
     const currentTime = new Date();
      const isMatch = doCronExpressionsMatch(serverCron, currentTime);


      if (isMatch) {
      // Check if userRef is a DocumentReference object
      if (userRef instanceof admin.firestore.DocumentReference) {
        const fcmTokensSnapshot = await userRef.collection('fcm_tokens').get();

        fcmTokensSnapshot.forEach(async (tokenDoc) => {
          const tokenData = tokenDoc.data();

          // Send push notification to the user using Firebase Messaging
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
            } catch (error) {
              console.error('Error sending message:', error);
            }
          }
        });
      }
    }
  });
}, null, true, 'UTC');

exports.checkAndSendNotifications = functions.pubsub.schedule('* * * * *').onRun(async (context) => {
  await checkAndSendNotifications();
});