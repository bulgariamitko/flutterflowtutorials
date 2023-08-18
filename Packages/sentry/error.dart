// code created by https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=aZCQwV8cvMw
// support my work - https://github.com/sponsors/bulgariamitko

import 'package:sentry/sentry.dart';

Future errorAction() async {
  print(['CUSTOM ERROR v1']);

  try {
    throw Exception('Testing Sentry Integration');
  } catch (exception, stackTrace) {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
    );
  }
}