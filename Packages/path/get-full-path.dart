// YouTube channel - https://www.youtube.com/@dimitarklaturov
// paid video - https://www.youtube.com/watch?v=LfAwHZndeWQ
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<String> getFullPath() async {
  String documentsPath = '';
  if (Platform.isIOS) {
    documentsPath = (await getApplicationDocumentsDirectory()).path;
  } else if (Platform.isAndroid) {
    documentsPath =
        (await getExternalStorageDirectory() ??
                await getApplicationDocumentsDirectory())
            .path;
  } else {
    throw UnsupportedError('Unsupported platform');
  }

  return documentsPath;
  // return p.join(documentsPath, fileName);
}
