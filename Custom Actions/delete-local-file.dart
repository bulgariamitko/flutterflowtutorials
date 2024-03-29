// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'dart:io';

Future<void> deleteFile(String? filePath) async {
  filePath ??= '';

  print('deleteFile');

  try {
    final file = File(filePath);

    if (await file.exists()) {
      await file.delete();
      print('File deleted successfully');
    } else {
      print('File does not exist');
    }
  } catch (e) {
    print('Error deleting file: $e');
  }
}
