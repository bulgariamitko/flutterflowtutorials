// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=aBC7A2oFsdM
// support my work - https://github.com/sponsors/bulgariamitko

const { triggerCheckAndSendNotifications } = require('./index');

async function triggerFunction() {
  await triggerCheckAndSendNotifications();
  console.log('Function checkAndSendNotifications manually triggered');
}

triggerFunction();