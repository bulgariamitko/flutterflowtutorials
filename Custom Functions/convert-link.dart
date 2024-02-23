// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

String covertLink(String? link) {
  link = link ?? '';

  String decoded = Uri.decodeFull(link);
  decoded = decoded.replaceAll(' ', '%20');
  decoded = decoded.replaceAll('…', '%20');
  decoded = decoded.replaceAll('...', '%20');

  return decoded;
}
