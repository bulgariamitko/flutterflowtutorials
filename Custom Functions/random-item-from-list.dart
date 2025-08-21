// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - no
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

String? randomItemFromList(List<String>? texts) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // null safety
  texts ??= [];

  String text = '';
  final random = math.Random();
  int index = random.nextInt(texts.length);
  text = texts[index];

  return text;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
