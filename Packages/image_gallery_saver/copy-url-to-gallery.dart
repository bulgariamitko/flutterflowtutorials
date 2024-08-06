// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart' as path;

Future<bool> copyUrlToGallery(String imageUrl) async {
  try {
    // Download the image from the URL
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to download image: ${response.statusCode}');
    }

    // Get the file name from the URL
    final String fileName = path.basename(imageUrl);

    // Save the file to the gallery
    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.bodyBytes),
      name: fileName,
      quality: 100,
    );

    return result['isSuccess'];
  } catch (e) {
    print('Error copying image from URL to gallery: $e');
    return false;
  }
}
