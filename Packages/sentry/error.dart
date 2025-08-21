// YouTube channel - https://www.youtube.com/@dimitarklaturov
// paid video - https://www.youtube.com/watch?v=aZCQwV8cvMw
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'package:sentry/sentry.dart';

Future errorAction() async {
  print(['CUSTOM ERROR v1']);

  try {
    throw Exception('Testing Sentry Integration');
  } catch (exception, stackTrace) {
    await Sentry.captureException(exception, stackTrace: stackTrace);
  }
}
