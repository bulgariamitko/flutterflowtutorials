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

Future<String> copyFileToAppDir(FFUploadedFile file) async {
  try {
    // Get the temporary directory
    final Directory tempDir = await getTemporaryDirectory();

    // Generate a unique filename using the original filename and current timestamp
    final String fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${file.name}';

    // Create the full path for the new file
    final String filePath = path.join(tempDir.path, fileName);

    // Write the bytes to the new file
    final File newFile = File(filePath);
    await newFile.writeAsBytes(file.bytes!);

    // Return the path of the newly created file
    return filePath;
  } catch (e) {
    print('Error copying file: $e');
    return '';
  }
}
