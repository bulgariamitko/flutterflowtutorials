// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - no
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

Future<String> saveFileFromUrlToLocal(
  String url,
  String? customFileName,
) async {
  try {
    // Get the temporary directory
    final Directory tempDir = await getTemporaryDirectory();
    // Get the application documents directory
    // final Directory appDocDir = await getApplicationDocumentsDirectory();

    // Download the file
    final http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Generate a unique filename using the custom filename (if provided) or extract from URL
      final String fileName =
          customFileName ??
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(url)}';

      // Create the full path for the new file
      final String filePath = path.join(tempDir.path, fileName);

      // Write the bytes to the new file
      final File newFile = File(filePath);
      await newFile.writeAsBytes(response.bodyBytes);

      // Return the path of the newly created file
      return filePath;
    } else {
      throw Exception('Failed to download file: ${response.statusCode}');
    }
  } catch (e) {
    print('Error saving file from URL: $e');
    return '';
  }
}
