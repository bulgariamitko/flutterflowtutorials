// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

List<LocationsRecord> filterLocation(
  List<LocationsRecord>? data,
  List<String>? locations,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

// null safety
  data ??= [];
  locations ??= [];

// Convert locations to lowercase
  List<String> lowerCaseLocations =
      locations.map((location) => location.toLowerCase()).toList();

  Set<LocationsRecord> filteredData = {};
  for (var d in data) {
    // Convert database results to lowercase and apply filters
    if (lowerCaseLocations.contains(d.town.toLowerCase()) ||
        lowerCaseLocations.contains(d.city.toLowerCase()) ||
        lowerCaseLocations.contains(d.state.toLowerCase()) ||
        lowerCaseLocations.contains(d.postcode.toString())) {
      filteredData.add(d);
    }
  }

  List<LocationsRecord> filteredDataList = filteredData.toList();

  return filteredDataList;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
