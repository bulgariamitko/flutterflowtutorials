// code created by https://www.youtube.com/@flutterflowexpert
// fb video - https://www.youtube.com/watch?v=nHz5o78L0x0
// fb update code video - https://youtube.com/watch?v=tWsr7dMKPcA
// support my work - https://github.com/sponsors/bulgariamitko

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
