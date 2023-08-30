// code created by https://www.youtube.com/@flutterflowexpert
// fb video - https://www.youtube.com/watch?v=HtvtwLmaI0w
// support my work - https://github.com/sponsors/bulgariamitko

import 'dart:math';

Future<VideosRow> getRandomRow() async {
  List<VideosRow> videos = await VideosTable().queryRows(queryFn: (q) => q);

  // Generate a random index within the range of available rows
  final random = Random();
  final randomIndex = random.nextInt(videos.length);

  // Retrieve the random row
  return videos[randomIndex];
}