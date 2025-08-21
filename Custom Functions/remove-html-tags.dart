// YouTube channel - https://www.youtube.com/@dimitarklaturov
// live video - no
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

String? removeHtmlTags(String? htmlString) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // null safety
  htmlString ??= '';

  final RegExp removeScripts = RegExp(
    r'<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>',
    multiLine: true,
    caseSensitive: true,
  );

  final RegExp removeTags = RegExp(
    r'<[^>]*>',
    multiLine: true,
    caseSensitive: true,
  );

  return htmlString.replaceAll(removeScripts, '').replaceAll(removeTags, '');

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
