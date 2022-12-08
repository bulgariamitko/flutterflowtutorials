// code created by https://www.youtube.com/@flutterflowexpert

import 'dart:math' as math;

List<String> filterDuplicates(List<String>? input) {
  input = input ?? [];

  return input.toSet().toList();
}