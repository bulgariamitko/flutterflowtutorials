// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

DateTime? calExpireDate(
  DateTime? date,
  int? daysTillExpire,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // null safety
  date ??= DateTime.now();
  daysTillExpire ??= 0;

  Duration thirtyDays = Duration(days: daysTillExpire);
  DateTime futureDate = date.add(thirtyDays);

  return futureDate;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}