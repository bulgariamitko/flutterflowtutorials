// code created by https://www.youtube.com/@flutterflowexpert
// video - no
// support my work - https://github.com/sponsors/bulgariamitko

List<String>? uniqueList(List<String>? inputList) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // null safety
  inputList ??= [];

// Create a Set from the input list
  Set<String> uniqueSet = Set<String>.from(inputList);

  // Convert the Set back to a List
  List<String> uniqueList = uniqueSet.toList();

  return uniqueList;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}