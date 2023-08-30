// YouTube channel - https://www.youtube.com/@flutterflowexpert
// fb video - https://youtube.com/watch?v=f3enSdgZ6oU
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

import 'dart:math';

Future<List<VideosRow>> shuffledRows() async {
  List<VideosRow> videos = await VideosTable().queryRows(queryFn: (q) => q);

  // Shuffle the list of videos.
  final random = Random();
  videos.shuffle(random);

  return videos;
}
