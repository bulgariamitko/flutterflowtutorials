// code created by https://www.youtube.com/@flutterflowexpert

bool ifContains(
  String? text,
  String? word,
) {
  text = text ?? '';
  word = word ?? '';

  if (text.contains(word)) {
    return true;
  }
  return false;
}