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
const amazonPaapi = require('amazon-paapi');

exports.amazonFindItem = functions.https.onRequest(async (request, response) => {
    // Write your code below!

  // Your credentials and common parameters
  const commonParameters = {
    AccessKey: '123',
    SecretKey: '123',
    PartnerTag: '123',
    PartnerType: 'Associates',
    Marketplace: 'www.amazon.com',
  };

  // Your request parameters
  const requestParameters = {
    Keywords: '9781491985571',
    Resources: ['ItemInfo.ExternalIds', 'Offers.Summaries.LowestPrice'],
    SearchIndex: 'All',
  };

    const myData = await amazonPaapi.SearchItems(commonParameters, requestParameters);
    res.json({ items: myData.SearchResult.Items });
    // Write your code above!
  }
);