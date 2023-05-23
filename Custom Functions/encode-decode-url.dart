// code created by https://www.youtube.com/@flutterflowexpert
// video - no
// support my work - https://github.com/sponsors/bulgariamitko

String? encodeURL(String? url, bool? encode) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // null safety
  url ??= '';
  encode ??= true;

  return encode ? Uri.encodeComponent(url) : Uri.decodeComponent(url);

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
