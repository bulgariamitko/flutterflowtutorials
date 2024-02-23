// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video -
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

const extensionBody: TaskBody = async({row, db, change, ref}) => {
  const { FieldValue } = require ("@google-cloud/firestore");
  var fsCounterCollection = db.collection('fs_counters').doc('ecUzLabKtMqYb7U0MXEj')
  const res = await fsCounterCollection.update({
    value: FieldValue.increment(1),
  });
}
