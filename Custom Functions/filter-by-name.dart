// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

List<CarsRecord> filterByName(
  List<CarsRecord>? data,
  String? searchName,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // null safety
  data ??= [];
  // Ensure that the searchName is not null and convert it to lowercase.
  final searchNameLower = searchName?.toLowerCase() ?? '';

  List<CarsRecord> filteredData = [];

  for (var d in data) {
    if (d.name.toLowerCase().contains(searchNameLower)) {
      filteredData.add(d);

      print(['FILTERED', d.name]);
    }
  }

  return filteredData;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
