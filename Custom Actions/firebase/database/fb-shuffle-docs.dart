// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://youtube.com/watch?v=f3enSdgZ6oU
// new video - https://www.youtube.com/watch?v=48D3V9JOvlU
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

import 'dart:math';

Future shuffleNames(List<ShuffingRecord>? users) async {
  // null safety
  users = users ?? [];

  int randomIndex = Random().nextInt(users.length);
  FFAppState().update(() {
    FFAppState().shuffleNames = users![randomIndex].name ?? '';
    FFAppState().winnerRef = users[randomIndex].reference;
  });
}