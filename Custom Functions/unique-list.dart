// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=yoiVwVOZW74
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

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
