// code created by https://www.youtube.com/@flutterflowexpert
// live video - no
// support my work - https://github.com/sponsors/bulgariamitko

String? removeHtmlTags(String? htmlString) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // null safety
  htmlString ??= '';

  final RegExp removeScripts = RegExp(
      r'<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>',
      multiLine: true,
      caseSensitive: true);

  final RegExp removeTags =
      RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);

  return htmlString.replaceAll(removeScripts, '').replaceAll(removeTags, '');

  /// MODIFY CODE ONLY ABOVE THIS LINE
}