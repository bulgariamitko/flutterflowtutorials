// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - https://www.youtube.com/watch?v=aBC7A2oFsdM
// replace - [{"Name of json auth file": "auth.json"}, {"Push notification title": "Your Title"}, {"Push notification description": "Your Description"}, {"The UID of the user you want to send the push notification to": "user-id"}, {"Collection name": "notifications"}, {"Person's name": "John Doe"}, {"Person's email": "johndoe@example.com"}, {"FCM token of the device (can take it from production db)": "very-long-fcm-token"}]
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

const admin = require('firebase-admin');
const serviceAccount = require('./auth.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

// Connect to the Firestore emulator
db.settings({
  host: 'localhost:8080',
  ssl: false
});

// Set the localCron value
const localCron = "*/1 * * * *";

// Get the current local time adjusted for the timezone offset
const now = new Date();
const timezoneOffsetMinutes = now.getTimezoneOffset();
const localUserTime = new Date(now.getTime() - timezoneOffsetMinutes * 60 * 1000).toISOString();

const serverCron = "*/1 * * * *";
const serverTime = new Date(now.getTime() - timezoneOffsetMinutes * 60 * 1000).toISOString();
const timeDiff = -90;

// Define title and desc
const title = "Your Title";
const desc = "Your Description";
const uid = "user-id";

// Create a reference to the user document
const userRef = admin.firestore().doc(`users/${uid}`);

// Create the notification data object
const notificationData = {
  localCron,
  localUserTime,
  serverCron,
  serverTime,
  timeDiff,
  title,
  desc,
  userRef,
};

// Add a new document to the notifications collection with the notification data
db.collection('notifications')
  .add(notificationData)
  .then((docRef) => {
    console.log('Document written with ID: ', docRef.id);
    // Add the user to the users collection
    db.collection('users').doc(uid).set({
      // Add any user data here, for example:
      name: "John Doe",
      email: "johndoe@example.com",
    }).then((userDoc) => {
      console.log('User added to the users collection');
        const fcmTokensRef = userRef.collection('fcm_tokens').doc(uid);
      fcmTokensRef.set({
        // Add any fcm_tokens data here, for example:
        created_at: new Date(),
        device_type: "Android",
        fcm_token: "very-long-fcm-token"
      }).then(() => {
        console.log('fcm_tokens added to the user document');
      }).catch((error) => {
        console.error('Error adding fcm_tokens to the user document: ', error);
      });
    }).catch((error) => {
      console.error('Error adding user to the users collection: ', error);
    });
  })
  .catch((error) => {
    console.error('Error adding document: ', error);
  });