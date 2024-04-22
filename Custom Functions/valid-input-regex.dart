// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

bool validateInput(
  String input,
  String regexCode,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  RegExp regex = RegExp(regexCode);

  // return regex.pattern;
  return regex.hasMatch(input);

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
