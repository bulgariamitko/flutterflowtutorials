// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

List<String> implodeStrings(String? data, String? delimiter) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // null safety
  data ??= '';
  delimiter ??= ', ';

  String joinedList = data.join(delimiter);

  return joinedList;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}