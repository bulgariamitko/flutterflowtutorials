// code created by https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=YcnKiZpo8ro
// support my work - https://github.com/sponsors/bulgariamitko

import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> getFCM() async {
  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  String token = await fcm.getToken() ?? '';

  return token;
}