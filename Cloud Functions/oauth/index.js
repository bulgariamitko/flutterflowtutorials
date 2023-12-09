// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=nC_Re2seyxs
// widgets - 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
// replace - [{"Dynamic link": "https://nufc2.page.link"}, {"Package name 1": "bg.nufc.nufc"}, {"Page routing name": "spotify"}]
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

const app = require('express')();
const admin = require('firebase-admin');
const functions = require('firebase-functions');
// To avoid deployment errors, do not call admin.initializeApp() in your code

app.get("/", async (req, res) => {
  const dynamicLink = "https://nufc2.page.link?apn=bg.nufc.nufc&ibi=bg.nufc.nufc&link=";
  const targetUrl = "https://nufc2.page.link/spotify";
  const newUrl = new URL(targetUrl);

  // Get the parameters from the URL
  // const params = req.query;

  // DEBUG: Create a new document in the 'spotify' collection
  // const docRef = admin.firestore().collection('spotify').doc();

  // Add code as query parameters
  newUrl.searchParams.append("code", req.query.code);

  // Create the final dynamic link with the encoded URL
  const finalDynamicLink = dynamicLink + encodeURIComponent(newUrl.toString());

  // DEBUG: Add the parameters to the document
  // await docRef.set({ params: params, 'url': finalDynamicLink });

  res.redirect(finalDynamicLink);
});

exports.spotifyauth = functions.https.onRequest(app);