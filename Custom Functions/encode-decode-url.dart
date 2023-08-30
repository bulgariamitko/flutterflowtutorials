// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

String? encodeURL(String? url, bool? encode) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // null safety
  url ??= '';
  encode ??= true;

  return encode ? Uri.encodeComponent(url) : Uri.decodeComponent(url);

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
