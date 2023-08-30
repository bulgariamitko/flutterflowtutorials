// YouTube channel - https://www.youtube.com/@flutterflowexpert
// sb video - https://youtube.com/watch?v=sCS3MfRuEUY
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

Future<List<VideosRow>> duplicateRows(
  String? searchField,
  String? searchValue,
) async {
  // null safety
  searchField ??= '';
  searchValue ??= '';

  List<VideosRow> result = [];

  List<VideosRow> videos = await VideosTable().queryRows(
    queryFn: (q) => q.eq(
      searchField ?? '',
      searchValue,
    ),
  );

  if (videos.length != 0) {
    for (int i = 0; i < videos.length; i++) {
      VideosRow createdVideo = await VideosTable().insert({
        'title': videos[i].title,
        'url': videos[i].url,
        'likes': videos[i].likes,
      });

      result.add(createdVideo);
    }
  }

  return result;
}