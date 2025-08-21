// YouTube channel - https://www.youtube.com/@dimitarklaturov
// paid video - https://youtu.be/Y82DsIHiPNI
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'package:http/http.dart' as http;

Future<dynamic> fetchCountry() async {
  final response = await http.get(
    Uri.parse('https://location-country.bulgaria-mitko.workers.dev/'),
  );

  dynamic data = {'country': 'no location'};

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    data = jsonDecode(response.body);
  }

  return data;
}
