// code created by https://www.youtube.com/@flutterflowexpert
// video - https://youtube.com/watch?v=IwhSbx1yN1M
// support my work - https://github.com/sponsors/bulgariamitko
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