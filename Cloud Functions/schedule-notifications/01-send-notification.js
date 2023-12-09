// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=nC_Re2seyxs
// replace - [{"File name": "auth.json"}]
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const moment = require('moment');
const cronParser = require('cron-parser');
const cron = require('cron');
const { CronJob } = cron;

function adjustCronField(field, adjustment, unit) {
  if (field === '*' || field.includes('-')) {
    return field;
  }

  const separator = field.includes(',') ? ',' : field.includes('/') ? '/' : '';

  if (separator) {
    const parts = field.split(separator).map((part, index) => {
      // If it's a step value (using '/'), adjust only the base value
      if (separator === '/' && index === 1) {
        return part;
      }

      const value = parseInt(part, 10);
      const adjustedValue = moment().set(unit, value).add(adjustment, unit).get(unit);
      return index === 0 && separator === '/' ? adjustedValue + separator + part : adjustedValue;
    });

    return parts.join(separator === ',' ? separator : '');
  }

  const value = parseInt(field, 10);
  return moment().set(unit, value).add(adjustment, unit).get(unit);
}

function calculateServerCron(localCron, localUserTime, timeDifference) {
  const localCronFields = localCron.split(' ');

  const localNext = cronParser.parseExpression(localCron).next().toDate();
  const serverNext = moment(localNext).add(timeDifference, 'minutes').toDate();

  // Use the "serverNext" variable to adjust each cron field individually
  localCronFields[0] = adjustCronField(localCronFields[0], serverNext.getMinutes() - localNext.getMinutes(), 'minute');
  localCronFields[1] = adjustCronField(localCronFields[1], serverNext.getHours() - localNext.getHours(), 'hour');

  const serverCron = localCronFields.join(' ');

  return serverCron;
}

exports.calculateServerTime = functions.firestore
  .document('notifications/{notificationId}')
  .onWrite(async (change, context) => {
    const { notificationId } = context.params;
    const newData = change.after.data();
    const previousData = change.before.data();

    // Check if localCron or localUserTime have been created or updated
    if (
      !previousData ||
      newData.localCron !== previousData.localCron ||
      newData.localUserTime !== previousData.localUserTime
    ) {
      // Ensure the necessary properties are present
      if (!newData.localCron || !newData.localUserTime) {
        return;
      }

      const { localUserTime, localCron, title, desc } = newData;

      // Calculate the difference between the local user's time and the server time (in minutes)
      const localUserMoment = moment(localUserTime);
      const serverMoment = moment.utc();
      let timeDifference = serverMoment.diff(localUserMoment, 'minutes');

      // Round the timeDifference to the nearest 30 minutes
      timeDifference = Math.round(timeDifference / 30) * 30;

      // Calculate the server cron using the provided function
      const serverCron = calculateServerCron(localCron, localUserTime, timeDifference);

      // Update the document with serverTime, serverCron, and timeDiff
      await admin
        .firestore()
        .collection('notifications')
        .doc(notificationId)
        .update({
          serverTime: serverMoment.format(),
          serverCron: serverCron,
          timeDiff: timeDifference,
          title: title,
          desc: desc,
        });
    }
});