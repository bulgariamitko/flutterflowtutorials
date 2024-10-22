// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

Future<void> closeTab() async {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  } else {
    // For web platform
    if (kIsWeb) {
      // Using js interop to close browser tab
      html.window.close();
    } else {
      SystemNavigator.pop(); // For mobile platforms
    }
  }
}
