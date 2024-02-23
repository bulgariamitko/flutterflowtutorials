// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

String truncate(
  String? input,
  int? maxLength,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  input ??= '';
  maxLength ??= 0;

  String truncated = input;
  if (input.length > maxLength) {
    truncated = input.substring(0, maxLength) + "...";
  }

  return truncated;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
