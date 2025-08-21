// YouTube channel - https://www.youtube.com/@dimitarklaturov
// paid video - no
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const { Logging } = require("@google-cloud/logging");
const logging = new Logging({
    projectId: process.env.GCLOUD_PROJECT,
});

exports.onUserDeleted = functions.auth.user().onDelete(async (user) => {
    let firestore = admin.firestore();
    let userRef = firestore.doc('users/' + user.uid);
    await firestore.collection("users").doc(user.uid).delete();
});

/**
 * To keep on top of errors, we should raise a verbose error report with Stackdriver rather
 * than simply relying on functions.logger.error. This will calculate users affected + send you email
 * alerts, if you've opted into receiving them.
 */

// [START reporterror]

function reportError(err) {
    // This is the name of the StackDriver log stream that will receive the log
    // entry. This name can be any valid log stream name, but must contain "err"
    // in order for the error to be picked up by StackDriver Error Reporting.
    const logName = "errors";
    const log = logging.log(logName);

    // https://cloud.google.com/logging/docs/api/ref_v2beta1/rest/v2beta1/MonitoredResource
    const metadata = {
        resource: {
            type: "cloud_function",
            labels: { function_name: process.env.FUNCTION_NAME },
        },
    };

    // https://cloud.google.com/error-reporting/reference/rest/v1beta1/ErrorEvent
    const errorEvent = {
        message: err.stack,
        serviceContext: {
            service: process.env.FUNCTION_NAME,
            resourceType: "cloud_function",
        },
    };

    // Write the error log entry
    return new Promise((resolve, reject) => {
        log.write(log.entry(metadata, errorEvent), (error) => {
            if (error) {
                return reject(error);
            }
            return resolve();
        });
    });
}

// [END reporterror]

/**
 * Sanitize the error message for the user.
 */
function userFacingMessage(error) {
    return error.type
        ? error.message
        : "An error occurred, developers have been alerted";
}
