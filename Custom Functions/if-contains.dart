// code created by https://www.youtube.com/@flutterflowexpert
// video - no
// support my work - https://github.com/sponsors/bulgariamitko

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