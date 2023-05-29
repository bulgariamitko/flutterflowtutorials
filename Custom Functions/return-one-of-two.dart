// code created by https://www.youtube.com/@flutterflowexpert
// video - no
// support my work - https://github.com/sponsors/bulgariamitko

String twoValuesOneReturn(
  String value1,
  String value2,
) {
  // return the value that is not empty of the two
  if (value1.isEmpty) {
    return value2;
  } else {
    return value1;
  }
}