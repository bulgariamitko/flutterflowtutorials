// YouTube channel - https://www.youtube.com/@dimitarklaturov
// paid video - https://www.youtube.com/watch?v=aZCQwV8cvMw
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import '../../main.dart' as main;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:provider/provider.dart';

Future sentrySetup() async {
  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  await SentryFlutter.init(
    (options) {
      options.dsn = '[YOUR-URL]';
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      ChangeNotifierProvider(
        create: (context) => appState,
        child: main.MyApp(),
      ),
    ),
  );
}
