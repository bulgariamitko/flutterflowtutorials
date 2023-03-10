// code created by https://www.youtube.com/@flutterflowexpert

String getUserLocation(LatLng? userLocation) {
  if (userLocation == null ||
      (userLocation.latitude == 0 && userLocation.longitude == 0)) {
    return '';
  }

  String location = "${userLocation.latitude},${userLocation.longitude}";
  return location;
}