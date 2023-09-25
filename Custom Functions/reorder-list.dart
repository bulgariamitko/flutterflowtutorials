// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=rrgw84My5tw
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

List<String> reorderList(
  List<String>? list,
  List<int>? order,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

// null safety
  list ??= [];
  order ??= [];

  if (list.length != order.length) {
    throw ArgumentError('List and order list must have the same length.');
  }

  List<String> result = List.filled(list.length, '');

  for (int i = 0; i < order.length; i++) {
    result[order[i]] = list[i];
  }

  return result;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}