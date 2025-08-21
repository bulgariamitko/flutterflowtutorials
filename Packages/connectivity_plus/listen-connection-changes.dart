// YouTube channel - https://www.youtube.com/@dimitarklaturov
// paid video -
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'package:connectivity_plus/connectivity_plus.dart';

Future listenConnectivityChanges() async {
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    bool isConnected = result != ConnectivityResult.none;
    // Use isConnected to update your UI or logic
    // true means connected, false means not connected
    FFAppState().update(() {
      FFAppState().offline = !isConnected;
    });
    print(['loop', isConnected]);
  });
}
