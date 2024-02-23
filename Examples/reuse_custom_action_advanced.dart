// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=rrgw84My5tw
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'dart:convert';

import 'package:download/download.dart';

import '../actions/add_to_num.dart';

Future widgetToImage() async {
  Uint8List image = base64.decode(FFAppState().widgetToExport);

  final fileName = "widget" + DateTime.now().toString() + ".png";

  final stream = Stream.fromIterable(image);
  download(stream, fileName);

  await addToNum();
}
