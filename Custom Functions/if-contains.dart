// code created by https://www.youtube.com/@flutterflowexpert

import 'dart:math' as math;

bool ifContains(
  String? text,
  String? word,
) {
  text = text ?? '';
  word = word ?? '';

  if (text.contains(word)) {
    return true;
  }
  return false;
}