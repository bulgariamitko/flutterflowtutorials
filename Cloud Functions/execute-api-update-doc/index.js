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
const axios = require('axios');

exports.executeAPIAndUpdateDoc = functions.pubsub.schedule('0 0 */29 * *').onRun((context) => {
    const usersRef = admin.firestore().collection('users');
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    // Query users with both fields 'tokenid' and 'lastpayment' not empty and lastpayment more than 30 days ago
   return usersRef
        .where('lastpayment', '<', thirtyDaysAgo)
        .get()
        .then((snapshot) => {
            snapshot.forEach((doc) => {
                // Check if 'tokenID' is not empty
                if (doc.data().tokenID) {
                    // Execute the API call for each user
                    executeAPICall(doc.data().tokenID, doc.data().lastamount);
                    // Update lastpayment date with current date and time
                    doc.ref.update({ lastpayment: admin.firestore.FieldValue.serverTimestamp() });
                }
            });
            return null;
        })
        .catch((error) => {
            console.error('Error checking and executing API:', error);
        });
});

function executeAPICall(tokenid, lastamount) {
    const apiEndpoint = 'https://api.example.com/v1/payments';
    const apiAuth = '1234';

        const amountPrice = parseInt(lastamount, 10);
    const currencyPrice = 'USD';
    const callback = 'https://myapp.app/success';
    const sourceData = {
        type: 'token',
        token: tokenid,
    };

    return axios.post(apiEndpoint, {
        amount: amountPrice,
        currency: currencyPrice,
        source: sourceData,
        callback_url: callback
    }, {
        headers: {
            'Authorization': `Basic ${apiAuth}`,
            'Content-Type': 'application/json'
        }
    })
    .then((response) => {
        console.log('API call success:', response.data);
    })
    .catch((error) => {
        console.error('API call failed:', error);
    });
}