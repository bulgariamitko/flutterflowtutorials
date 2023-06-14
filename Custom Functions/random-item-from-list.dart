// code created by https://www.youtube.com/@flutterflowexpert
// video - https://youtube.com/watch?v=f3enSdgZ6oU
// support my work - https://github.com/sponsors/bulgariamitko

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