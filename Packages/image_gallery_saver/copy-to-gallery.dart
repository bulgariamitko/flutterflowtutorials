// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'dart:io';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart' as path;

Future<bool> copyToGallery(String filePath) async {
  try {
    // Read the file as bytes
    final File file = File(filePath);
    final Uint8List bytes = await file.readAsBytes();

    // Get the file name
    final String fileName = path.basename(filePath);

    // Save the file to the gallery
    final result = await ImageGallerySaver.saveFile(
      filePath,
      name: fileName,
    );

    return result['isSuccess'];
  } catch (e) {
    print('Error copying file to gallery: $e');
    return false;
  }
}
