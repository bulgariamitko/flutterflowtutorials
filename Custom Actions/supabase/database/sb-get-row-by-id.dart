// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=0_TIH7xT5_Y&t=1s
// replace - [{"Collection name": "Cars"}]
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

Future<VideosRow> getRowById(
  String? idValue,
) async {
  // null check
  idValue ??= 'error';

  List<VideosRow> videos = await VideosTable().queryRows(
      queryFn: (q) => q.eq(
            'id',
            idValue,
          ));

  return videos[0];
}
