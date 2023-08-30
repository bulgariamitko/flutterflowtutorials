// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=aBC7A2oFsdM
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

const { triggerCheckAndSendNotifications } = require('./index');

async function triggerFunction() {
  await triggerCheckAndSendNotifications();
  console.log('Function checkAndSendNotifications manually triggered');
}

triggerFunction();