// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=0_TIH7xT5_Y
// new video - https://www.youtube.com/watch?v=48D3V9JOvlU
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
