// code created by https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=kr-OlNuvzQU
// support my work - https://github.com/sponsors/bulgariamitko

List<UpcomingQuestsRow> shuffleOrder(List<UpcomingQuestsRow>? data) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  data ??= [];

// Shuffle the list
  final random = math.Random();
  data.shuffle(random);

  return data;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
