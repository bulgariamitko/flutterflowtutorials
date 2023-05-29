// code created by https://www.youtube.com/@flutterflowexpert
// video - no
// support my work - https://github.com/sponsors/bulgariamitko

String increaseNum(String? input) {
  input = input ?? '';
  String output = (int.parse(input) + 1).toString();

  return output;
}