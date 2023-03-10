// code created by https://www.youtube.com/@flutterflowexpert

String joinList(List<String>? strings) {
  strings = strings ?? [];
  String combined = strings.join(',');

  return combined;
}