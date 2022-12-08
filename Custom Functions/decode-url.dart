// code created by https://www.youtube.com/@flutterflowexpert

import 'dart:math' as math;

String decodeUrl(String? url) {
  url = url ?? '';

  String decoded = Uri.decodeFull(url);
  String withoutSpaces = decoded.replaceAll(' ', '-');

  return withoutSpaces;
}