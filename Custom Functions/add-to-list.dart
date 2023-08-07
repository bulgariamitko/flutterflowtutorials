// code created by https://www.youtube.com/@flutterflowexpert
// video - no
// support my work - https://github.com/sponsors/bulgariamitko

List<String>? addToList(
  String? value,
  List<String>? originalList,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // null safety
  value ??= '';
  originalList ??= [];

  originalList.add(value);
  return originalList;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
