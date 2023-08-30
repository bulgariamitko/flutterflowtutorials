// YouTube channel - https://www.youtube.com/@flutterflowexpert
// fb video - https://youtube.com/watch?v=Lt0irFF_NpE
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

Future<List<VideosRow>> getRowsUsingTable() async {
  List<VideosRow> videos = await VideosTable().queryRows(queryFn: (q) => q);

  return videos;
}
