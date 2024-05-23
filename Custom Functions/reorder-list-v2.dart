// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

Future<List<String>> reorderItems(
  List<String>? list,
  int? oldIndex,
  int? newIndex,
) async {
  // null safety
  list ??= [];
  oldIndex ??= 0;
  newIndex ??= 0;

  if (oldIndex < newIndex) {
    newIndex -= 1;
  }

  final item = list.removeAt(oldIndex);
  list.insert(newIndex, item);

  return list;
}
