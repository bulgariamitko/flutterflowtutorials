// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=YcnKiZpo8ro
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> getFCM() async {
  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  String token = await fcm.getToken() ?? '';

  return token;
}