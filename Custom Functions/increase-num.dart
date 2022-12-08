// code created by https://www.youtube.com/@flutterflowexpert

import 'dart:math' as math;

String increaseNum(String? input) {
  input = input ?? '';
  String output = (int.parse(input) + 1).toString();

  return output;
}