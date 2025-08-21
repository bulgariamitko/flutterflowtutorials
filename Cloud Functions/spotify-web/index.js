// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - no
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

const functions = require('firebase-functions');
const admin = require('firebase-admin');
// Ensure you have initialized Firebase Admin SDK appropriately somewhere in your code if necessary.
const axios = require('axios');

exports.spotifyWeb = functions.https.onCall(async (data, context) => {
    const token = data.token;
    const authCode = data.authCode;

    // Define the URL and the headers for the POST request
    const url = 'https://accounts.spotify.com/api/token';
    const headers = {
        Authorization: 'Basic ' + token,
        'Content-Type': 'application/x-www-form-urlencoded',
    };

    // Define the data for the POST request (avoiding variable naming conflict by using a different variable name)
    const postData = new URLSearchParams({
        grant_type: 'authorization_code',
        code: authCode,
        redirect_uri: 'https://spotifyapp.flutterflow.app/spotify'
    }).toString();

    try {
        // Make the POST request to the Spotify API
        const response = await axios.post(url, postData, { headers });

        // Return the JSON response data directly
        return { data: response.data };
    } catch (error) {
        console.error('Error making the API request:', error);
        // Throwing an error back to the client
        throw new functions.https.HttpsError('unknown', 'Failed to make API request', error.message);
    }
});