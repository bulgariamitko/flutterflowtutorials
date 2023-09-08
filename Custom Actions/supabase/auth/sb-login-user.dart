// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

import '../../auth/supabase_auth/auth_util.dart';

Future authLoginUser(
  BuildContext context,
  String? email,
  String? password,
) async {
  // null safety
  email ??= '';
  password ??= '';

  final user = await authManager.signInWithEmail(
    context,
    email,
    password,
  );

  print(user);

  // return user;
}