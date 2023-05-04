// code created by https://www.youtube.com/@flutterflowexpert
// future video - https://www.youtube.com/watch?v=_2KJuCccuhg
// support my work - https://github.com/sponsors/bulgariamitko

const { triggerCheckAndSendNotifications } = require('./index');

async function triggerFunction() {
  await triggerCheckAndSendNotifications();
  console.log('Function checkAndSendNotifications manually triggered');
}

triggerFunction();