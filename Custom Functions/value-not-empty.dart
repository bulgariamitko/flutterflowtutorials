// YouTube channel - https://www.youtube.com/@flutterflowexpert

bool valueNotEmpty(String? value) {
  // if value not empty return true else return false
  return value != '' &&
      value.toString() != '0' &&
      value != null &&
      value.isNotEmpty;
}