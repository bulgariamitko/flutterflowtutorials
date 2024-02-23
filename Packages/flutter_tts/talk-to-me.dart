// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://youtube.com/watch?v=kcqrHDqpmoo
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'package:flutter_tts/flutter_tts.dart';

Future talkToMe() async {
  FlutterTts flutterTts = FlutterTts();
  flutterTts.setLanguage("en-US");
  // flutterTts.setVoice({"name": "Wavenet-A", "locale": "en-US"});
  String text = FFAppState().tts;
  flutterTts.speak(text);
}
