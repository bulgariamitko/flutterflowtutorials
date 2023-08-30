// YouTube channel - https://www.youtube.com/@flutterflowexpert
// fb video - https://www.youtube.com/watch?v=HtvtwLmaI0w
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

Future<VideosRow> getRow(
  String? searchField,
  String? searchValue,
) async {
  // null check
  searchField ??= 'error';
  searchValue ??= 'error';

  List<VideosRow> videos = await VideosTable().queryRows(
      queryFn: (q) => q.eq(
            searchField ?? '',
            searchValue,
          ));

  return videos[0];
}
