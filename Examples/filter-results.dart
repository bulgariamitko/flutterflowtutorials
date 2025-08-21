// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - no
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

List<EstateRecord> filterResults(
  List<EstateRecord>? data,
  List<String>? locations,
  List<String>? types,
  int? beds,
  int? baths,
  int? carparking,
  double? priceMin,
  double? priceMax,
  int? landsizesqmMin,
  int? landsizesqmMax,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // null safety
  data ??= [];
  locations ??= [];
  List<String> lowerCaseLocations = locations
      .map((location) => location.toLowerCase())
      .toList();

  Set<EstateRecord> filteredData = {};
  for (var d in data) {
    bool shouldAdd = true;

    print(
      "Debug Data: townSuburb=${d.townSuburb}, city=${d.city}, state=${d.state}, type=${d.type}, beds=${d.beds}, baths=${d.baths}, carParking=${d.carParking}, price=${d.price}, landSizeSqm=${d.landSizeSqm}",
    );
    print(
      "Debug Filters: locations=$locations, types=$types, beds=$beds, baths=$baths, carparking=$carparking, priceMin=$priceMin, priceMax=$priceMax, landsizesqmMin=$landsizesqmMin, landsizesqmMax=$landsizesqmMax",
    );

    if (locations.isNotEmpty) {
      shouldAdd =
          shouldAdd &&
          (lowerCaseLocations.contains(d.townSuburb.toLowerCase()) ||
              lowerCaseLocations.contains(d.city.toLowerCase()) ||
              lowerCaseLocations.contains(d.state.toLowerCase()) ||
              lowerCaseLocations.contains(d.postcode.toString()));
    }

    if (types != null && types.isNotEmpty) {
      shouldAdd = shouldAdd && types.contains(d.type);
    }

    if (beds != null && beds != 0) {
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
