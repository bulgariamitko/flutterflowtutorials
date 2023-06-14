// code created by https://www.youtube.com/@flutterflowexpert
// video - no
// support my work - https://github.com/sponsors/bulgariamitko

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