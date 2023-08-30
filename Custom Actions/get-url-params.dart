// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=EwGeOgSjEsM
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

import 'dart:html';

Future getPageParamas(
  String? param1,
  String? param2,
) async {
  // null safety
  param1 ??= '';
  param2 ??= '';

  // Get the current URL
  String currentUrl = window.location.href;

  // Parse the URL
  Uri uri = Uri.parse(currentUrl);

  // Get individual parameter values
  FFAppState().authCode = uri.queryParameters[param1] ?? '';
  FFAppState().score = uri.queryParameters[param2] ?? '';
}