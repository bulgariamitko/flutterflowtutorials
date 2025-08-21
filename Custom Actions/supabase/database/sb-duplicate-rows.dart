// YouTube channel - https://www.youtube.com/@dimitarklaturov
// paid video - https://www.youtube.com/watch?v=0_TIH7xT5_Y&t=1s
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

Future<List<VideosRow>> duplicateRows(
  String? searchField,
  String? searchValue,
) async {
  // null safety
  searchField ??= '';
  searchValue ??= '';

  List<VideosRow> result = [];

  List<VideosRow> videos = await VideosTable().queryRows(
    queryFn: (q) => q.eq(searchField ?? '', searchValue),
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
