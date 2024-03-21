// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

String filterBymiles(
  LatLng? userLocation,
  LatLng? userRef2,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  if (userLocation == null || userRef2 == null) {
    return 'Error: Both userLocation and userRef2 must be provided';
  }

  // Define distanceInMiles function
  double distanceInMiles(LatLng userLocation, LatLng userRef2) {
    const double earthRadius = 3958.8; // Earth's radius in miles

    // Convert latitude and longitude from degrees to radians
    final double lat1Rad = math.pi / 180.0 * userLocation.latitude;
    final double lon1Rad = math.pi / 180.0 * userLocation.longitude;
    final double lat2Rad = math.pi / 180.0 * userRef2.latitude;
    final double lon2Rad = math.pi / 180.0 * userRef2.longitude;

    // Calculate differences in latitude and longitude
    final double dLat = lat2Rad - lat1Rad;
    final double dLon = lon2Rad - lon1Rad;

    // Calculate Haversine formula components
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    // Calculate distance
    final double distance = earthRadius * c;

    // Return the calculated distance
    return distance;
  }

  // Calculate distance between userLocation and userRef2
  double distance = distanceInMiles(userLocation, userRef2);

  // Return the calculated distance in miles
  return 'Distance between users: ${distance.toStringAsFixed(2)} miles';

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
