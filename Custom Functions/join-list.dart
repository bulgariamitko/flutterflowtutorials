// code created by https://www.youtube.com/@flutterflowexpert

import 'dart:math' as math;

String joinList(List<String>? strings) {
  strings = strings ?? [];
  String combined = strings.join(',');

  return combined;
}