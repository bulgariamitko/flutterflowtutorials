// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - https://youtube.com/watch?v=f3enSdgZ6oU
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

String? randomInt() {
  /// MODIFY CODE ONLY BELOW THIS LINE

  final random = math.Random();
  int randomInt = random.nextInt(999) + 1;
  String randomImg = "https://picsum.photos/seed/$randomInt/600";

  return randomImg;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
