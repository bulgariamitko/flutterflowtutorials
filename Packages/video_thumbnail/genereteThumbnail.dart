// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - no
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> generateThumbnail(String videoPath) async {
  final directory = await getApplicationDocumentsDirectory();
  final thumbnailPath =
      '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';

  final thumbnail = await VideoThumbnail.thumbnailFile(
    video: videoPath,
    thumbnailPath: thumbnailPath,
    imageFormat: ImageFormat.PNG,
    maxHeight: 640,
    maxWidth: 480,
    quality: 100,
  );

  return thumbnail ?? '';
}
