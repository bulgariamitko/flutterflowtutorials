const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { v4: uuidv4 } = require('uuid');

exports.addARandomUserData = functions.https.onRequest(async (req, res) => {
    // Get a random user's document reference from the 'users' collection
    const userRef = admin.firestore().collection('users').doc(uuidv4());

    // Create a new user data object with random data
    const newUserData = {
        identifier: Math.floor(Math.random() * 1000000),
        myBool: Math.random() < 0.5,
        myDate: admin.firestore.Timestamp.now(),
        myRef: userRef,
        username: `user_${uuidv4()}`,
        myList: [`item1`, `item2`, `item3`],
        location: new admin.firestore.GeoPoint(Math.random() * (90 - (-90)) + (-90), Math.random() * (180 - (-180)) + (-180))
    };

    // Add the new user data to the 'usersdata' collection
    try {
        const docRef = await admin.firestore().collection('usersdata').add(newUserData);
        res.send(`New user data created with ID: ${docRef.id}`);
    } catch (error) {
        console.error("Error adding new user data: ", error);
        res.status(500).send("Error creating new user data");
    }
});