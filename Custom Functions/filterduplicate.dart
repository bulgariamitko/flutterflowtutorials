// code created by https://www.youtube.com/@flutterflowexpert
// video - no
// support my work - https://github.com/sponsors/bulgariamitko

List<String> filterDuplicates(List<String>? input) {
  input = input ?? [];

  return input.toSet().toList();
}