// code created by https://www.youtube.com/@flutterflowexpert
// sb video - https://www.youtube.com/watch?v=HtvtwLmaI0w
// replace - [{"Collection name": "Cars"}]
// support my work - https://github.com/sponsors/bulgariamitko

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