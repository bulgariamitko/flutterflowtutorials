// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://youtube.com/watch?v=IwhSbx1yN1M
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY
// source - https://community.flutterflow.io/authentication/post/check-if-user-use-google-auth-F1kIWPgHITtPz9w

import 'package:firebase_auth/firebase_auth.dart';

String? getUserSignInMethod() {
  final user = FirebaseAuth.instance.currentUser;
  String? signInMethod = null;
  for (var info in user!.providerData) {
    signInMethod = info.providerId;
  }
  return signInMethod;
}