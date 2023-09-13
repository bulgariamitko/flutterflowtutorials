// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

// Note: This code can be used as a custom function as well

Future<List<dynamic>> convertDataToJson(List<UserStruct>? data) async {
  // Null safety
  data ??= [];

  List<dynamic> users = [];
  for (UserStruct userData in data) {
    final CompanyStruct company = userData.company;
    final double lat = userData.location!.latitude;
    final double lng = userData.location!.longitude;

    // Create a Map (JSON format) representing the user
    final userJson = {
      'company': {'name': company.name},
      'email': userData.email,
      'location': {'lat': lat, 'lng': lng},
      'name': userData.name,
      'phone': userData.phone,
      'username': userData.username,
    };

    users.add(userJson);
  }

  return users;
}