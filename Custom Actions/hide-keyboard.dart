// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

Future hideKeyboard() async {
  // This will hide the keyboard by removing focus from the current input field
  FocusScope.of(context).unfocus();
}
