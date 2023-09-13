// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

// Note: This code can be used as a custom function as well

Future<List<UserStruct>> convertJSONtoDT(List<dynamic>? data) async {
  // null safety
  data ??= [];

  List<UserStruct> users = [];
  for (dynamic userData in data) {
    final dynamic address = userData['address'];
    final double lat = double.parse(address['geo']['lat']);
    final double lng = double.parse(address['geo']['lng']);

    final company = CompanyStruct(name: userData['company']['name']);
    final user = UserStruct(
      company: company,
      email: userData['email'],
      location: LatLng(lat, lng),
      name: userData['name'],
      phone: userData['phone'],
      username: userData['username'],
    );

    users.add(user);
  }

  return users;
}