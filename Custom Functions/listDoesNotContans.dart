// code created by https://www.youtube.com/@flutterflowexpert
// video - no
// support my work - https://github.com/sponsors/bulgariamitko

bool listDoesNotContains(
  List<String>? input,
  String? word,
) {
  input = input ?? [];
  word = word ?? '';

  return !input.contains(word);
}