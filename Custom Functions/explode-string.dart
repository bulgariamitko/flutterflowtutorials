// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

List<String> explodeString(String? data, String? delimiter) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // null safety
  data ??= '';
  delimiter ??= ',';

  final parts = data.split(delimiter);
  final trimmedParts = parts.map((part) => part.trim()).toList();

  return trimmedParts;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
