// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - https://youtube.com/watch?v=kcqrHDqpmoo
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

dynamic chatGPTConverter(String? message) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // null safety
  message ??= '';

  List<dynamic> result = [];

  // add the role
  result.add({"role": "user", "content": message});
  print(result);
  return result;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
