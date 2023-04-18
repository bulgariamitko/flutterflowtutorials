// code created by https://www.youtube.com/@flutterflowexpert
// video - https://youtube.com/watch?v=kcqrHDqpmoo
// support my work - https://github.com/sponsors/bulgariamitko

import 'package:flutter_tts/flutter_tts.dart';

Future talkToMe() async {
  FlutterTts flutterTts = FlutterTts();
  flutterTts.setLanguage("en-US");
  // flutterTts.setVoice({"name": "Wavenet-A", "locale": "en-US"});
  String text = FFAppState().tts;
  flutterTts.speak(text);
}