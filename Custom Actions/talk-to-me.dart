// code created by https://www.youtube.com/@flutterflowexpert
// video - https://youtu.be/kcqrHDqpmoo
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

import 'package:flutter_tts/flutter_tts.dart';

Future talkToMe() async {
  FlutterTts flutterTts = FlutterTts();
  flutterTts.setLanguage("en-US");
  // flutterTts.setVoice({"name": "Wavenet-A", "locale": "en-US"});
  String text = FFAppState().tts;
  flutterTts.speak(text);
}