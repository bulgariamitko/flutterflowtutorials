// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - no
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

List<String>? addToList(String? value, List<String>? originalList) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // null safety
  value ??= '';
  originalList ??= [];

  originalList.add(value);
  return originalList;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
