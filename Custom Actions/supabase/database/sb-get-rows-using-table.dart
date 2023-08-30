// code created by https://www.youtube.com/@flutterflowexpert
// fb video - https://youtube.com/watch?v=Lt0irFF_NpE
// support my work - https://github.com/sponsors/bulgariamitko

Future<List<VideosRow>> getRowsUsingTable() async {
  List<VideosRow> videos = await VideosTable().queryRows(queryFn: (q) => q);

  return videos;
}
