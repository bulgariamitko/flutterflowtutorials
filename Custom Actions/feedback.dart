// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - no
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'package:vibration/vibration.dart';

Future feedbackText(String inputText, int typeDelay) async {
  // Add your function code here!
  var delay = Duration(milliseconds: typeDelay); // 500 milliseconds delay
  var appState = FFAppState();

  typeLikeChatGPT(inputText, delay).listen((character) {
    appState.update(() {
      appState.feedbackText += character;
      if (character == ' ' || appState.feedbackText.endsWith(inputText)) {
        // Vibration for each word (or at the end of the text)
        if (FFAppState().hapticFeedback) {
          Vibration.vibrate(duration: 30, amplitude: 50);
        }
      }
    });
  });
}

Stream<String> typeLikeChatGPT(String text, Duration delay) async* {
  var words = text.split(' ');
  for (var word in words) {
    for (var character in word.split('')) {
      yield character;
    }
    yield ' '; // Yield a space after each word
    await Future.delayed(delay); // Delay after each word
  }
}
