// YouTube channel - https://www.youtube.com/@flutterflowexpert
// fb video - https://www.youtube.com/watch?v=nHz5o78L0x0
// fb update code video - https://youtube.com/watch?v=tWsr7dMKPcA
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

Future<List<VideosRow>> getRowsUsingFilter(
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

  return videos;
}
