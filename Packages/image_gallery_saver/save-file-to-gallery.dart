// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - no
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'package:flutter/foundation.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart' as path;

Future<String> saveFileToGallery(FFUploadedFile file) async {
  try {
    // Generate a unique filename using the original filename and current timestamp
    final String fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${file.name}';

    // Save the file to the gallery
    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(file.bytes!),
      name: fileName,
      isReturnImagePathOfIOS: true,
    );

    if (result['isSuccess']) {
      // On Android, result['filePath'] will be the path.
      // On iOS, we need to use result['path'] instead.
      final String savedPath = defaultTargetPlatform == TargetPlatform.iOS
          ? result['path']
          : result['filePath'];

      print('File saved to gallery: $savedPath');
      return savedPath;
    } else {
      print('Failed to save file to gallery');
      return '';
    }
  } catch (e) {
    print('Error saving file to gallery: $e');
    return '';
  }
}
