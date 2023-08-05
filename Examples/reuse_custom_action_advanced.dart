// code created by https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=rrgw84My5tw
// support my work - https://github.com/sponsors/bulgariamitko

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