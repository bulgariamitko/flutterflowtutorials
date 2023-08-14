// code created by https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=EwGeOgSjEsM
// support my work - https://github.com/sponsors/bulgariamitko

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