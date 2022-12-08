// code created by https://www.youtube.com/@flutterflowexpert

import 'dart:math' as math;

bool valueNotEmpty(String? value) {
  // if value not empty return true else return false
  return value != '' &&
      value.toString() != '0' &&
      value != null &&
      value.isNotEmpty;
}