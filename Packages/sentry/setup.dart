// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=aZCQwV8cvMw
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

import '../../main.dart' as main;

import 'package:sentry_flutter/sentry_flutter.dart';

Future setupSentry() async {
  print(['SENTRY SETUP v1']);

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://3a8fe8f42ea9f2147242f072d3d431e3@o390943.ingest.sentry.io/4505702385123328';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () {
      // Wrap your app with a custom error handler that captures uncaught errors
      FlutterError.onError = (details) {
        Sentry.captureException(
          details.exception,
          stackTrace: details.stack,
        );
      };
      runApp(main.MyApp());
    },
  );
}