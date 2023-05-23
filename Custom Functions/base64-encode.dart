// code created by https://www.youtube.com/@flutterflowexpert
// video - no
// support my work - https://github.com/sponsors/bulgariamitko

String? toBase64(String? input) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // null safety
  input ??= '';

  var bytes = utf8.encode(input);
  return base64.encode(bytes);

  /// MODIFY CODE ONLY ABOVE THIS LINE
}