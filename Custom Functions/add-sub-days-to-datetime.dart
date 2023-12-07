// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

DateTime addDaysToDateTime(
  int? days,
  DateTime? currentDT,
  bool? isAddition,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // null safety

  days ??= 0;
  currentDT ??= DateTime.now();
  isAddition ??= true;

  // Determine whether to add or subtract days
  if (isAddition) {
    // Add days
    return currentDT.add(Duration(days: days));
  } else {
    // Subtract days
    return currentDT.subtract(Duration(days: days));
  }

  /// MODIFY CODE ONLY ABOVE THIS LINE
}