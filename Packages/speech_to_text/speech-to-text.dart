// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - https://youtube.com/watch?v=6BCOl4w0mcI
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'dart:async';
import 'dart:math';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

Future<void> speechToText(
  Future Function(String words) listeningCallback,
  Future Function(String words) finalCallback,
) async {
  bool _onDevice = false;
  final int listenForSeconds = 30;
  final int pauseForSeconds = 3;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  final SpeechToText speech = SpeechToText();

  try {
    bool isInitialized = await speech.initialize(
      onError: (error) {
        print('Speech recognition error: ${error.errorMsg}');
      },
      onStatus: (status) {
        print('Speech recognition status: $status');
      },
    );

    if (!isInitialized) {
      print('Speech recognition initialization failed');
      return;
    }

    var systemLocale = await speech.systemLocale();
    String currentLocaleId = systemLocale?.localeId ?? '';

    if (!speech.isAvailable) {
      print('Speech recognition is not available');
      return;
    }

    await speech.listen(
      onResult: (SpeechRecognitionResult result) async {
        if (!result.finalResult) {
          // Partial results - listening
          await listeningCallback(result.recognizedWords);
        } else {
          // Final results
          await finalCallback(result.recognizedWords);
        }
      },
      listenFor: Duration(seconds: listenForSeconds),
      pauseFor: Duration(seconds: pauseForSeconds),
      partialResults: true,
      localeId: currentLocaleId,
      onSoundLevelChange: (level) {
        minSoundLevel = min(minSoundLevel, level);
        maxSoundLevel = max(maxSoundLevel, level);
        print('Sound level $level: $minSoundLevel - $maxSoundLevel');
      },
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
      onDevice: _onDevice,
    );
  } catch (e) {
    print('Error in speech recognition: $e');
  }
}
