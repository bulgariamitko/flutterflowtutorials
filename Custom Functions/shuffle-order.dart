// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=kr-OlNuvzQU
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

List<UpcomingQuestsRow> shuffleOrder(List<UpcomingQuestsRow>? data) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  data ??= [];

// Shuffle the list
  final random = math.Random();
  data.shuffle(random);

  return data;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
