// code created by https://www.youtube.com/@flutterflowexpert
// fb video - https://youtube.com/watch?v=f3enSdgZ6oU
// support my work - https://github.com/sponsors/bulgariamitko

import 'dart:math';

Future<List<VideosRow>> shuffledRows() async {
  List<VideosRow> videos = await VideosTable().queryRows(queryFn: (q) => q);

  // Shuffle the list of videos.
  final random = Random();
  videos.shuffle(random);

  return videos;
}
