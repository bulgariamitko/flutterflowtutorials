// code created by https://www.youtube.com/@flutterflowexpert
// video - no
// support my work - https://github.com/sponsors/bulgariamitko

bool? compareDates(
  DateTime? todayDate,
  DateTime? expireDate,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // null safety
  todayDate ??= DateTime.now();
  expireDate ??= DateTime.now();

  bool subExpired = false;
  if (todayDate.isBefore(expireDate)) {
    subExpired = true;
  }

  return subExpired;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}