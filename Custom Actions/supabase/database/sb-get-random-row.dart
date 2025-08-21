// YouTube channel - https://www.youtube.com/@dimitarklaturov
// paid video - https://www.youtube.com/watch?v=0_TIH7xT5_Y&t=1s
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'dart:math';

Future<VideosRow> getRandomRow() async {
  List<VideosRow> videos = await VideosTable().queryRows(queryFn: (q) => q);

  // Generate a random index within the range of available rows
  final random = Random();
  final randomIndex = random.nextInt(videos.length);

  // Retrieve the random row
  return videos[randomIndex];
}
