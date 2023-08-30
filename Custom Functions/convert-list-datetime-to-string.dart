// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

List<String>? convertDateTimesToStrings(
  List<DateTime>? dateTimes,
  String? format,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // null safety
  dateTimes ??= [];
  format ??= 'yyyy-MM-dd';

  List<String> dateStrings = [];

  for (DateTime dateTime in dateTimes) {
    String dateString = dateTime.toIso8601String().substring(0, format.length);
    dateStrings.add(dateString);
  }

  return dateStrings;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
