// code created by https://www.youtube.com/@flutterflowexpert

bool listDoesNotContains(
  List<String>? input,
  String? word,
) {
  input = input ?? [];
  word = word ?? '';

  return !input.contains(word);
}