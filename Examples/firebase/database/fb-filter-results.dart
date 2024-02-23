// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

// this is a custom function

List<PropertyRecord> filterResults(
  List<PropertyRecord>? data,
  List<String>? locations,
  List<String>? types,
  int? beds,
  int? baths,
  int? carparking,
  double? priceMin,
  double? priceMax,
  int? landsizesqmMin,
  int? landsizesqmMax,
  bool? status,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

// null safety.
  data ??= [];
  locations ??= [];
  List<String> lowerCaseLocations =
      locations.map((location) => location.toLowerCase()).toList();

  List<PropertyRecord> filteredData = [];

  for (var d in data) {
    bool shouldAdd = true;

    if (lowerCaseLocations.isNotEmpty) {
      shouldAdd = shouldAdd &&
          (lowerCaseLocations.contains(d.town.toLowerCase()) ||
              lowerCaseLocations.contains(d.city.toLowerCase()) ||
              lowerCaseLocations.contains(d.state.toLowerCase()) ||
              lowerCaseLocations.contains(d.postcode.toString()));
    }

    if (types != null && types.isNotEmpty) {
      shouldAdd = shouldAdd && types.contains(d.type);
    }

    if (beds != null && beds != 0) {
      // shouldAdd = shouldAdd && (beds > 5 ? d.beds >= beds : d.beds == beds);
      shouldAdd = shouldAdd && d.beds >= beds;
    }

    if (baths != null && baths != 0) {
      shouldAdd = shouldAdd && d.baths >= baths;
    }

    if (carparking != null && carparking != 0) {
      shouldAdd = shouldAdd && d.carParking >= carparking;
    }

    if (priceMin != null && priceMin != 0) {
      shouldAdd = shouldAdd && d.price >= priceMin;
    }

    if (priceMax != null && priceMax != 0) {
      shouldAdd = shouldAdd && d.price <= priceMax;
    }

    if (landsizesqmMin != null && landsizesqmMin != 0) {
      shouldAdd = shouldAdd && d.landSizeSqm >= landsizesqmMin;
    }

    if (landsizesqmMax != null && landsizesqmMax != 0) {
      shouldAdd = shouldAdd && d.landSizeSqm <= landsizesqmMax;
    }

    if (shouldAdd) {
      filteredData.add(d);
    }
  }

  return filteredData.toList();

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
