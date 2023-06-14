// code created by https://www.youtube.com/@flutterflowexpert
// video - no
// support my work - https://github.com/sponsors/bulgariamitko

String? replaceText(
  String? text,
  String? toReplace,
  String? replacement,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // null safety
  text ??= '';
  toReplace ??= '';
  replacement ??= '';

  String newText = text.replaceAll(toReplace, replacement);

  return newText;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}