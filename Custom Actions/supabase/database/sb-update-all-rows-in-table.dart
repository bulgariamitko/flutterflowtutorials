// code created by https://www.youtube.com/@flutterflowexpert
// fb video - https://www.youtube.com/watch?v=nHz5o78L0x0
// fb update code video - https://youtube.com/watch?v=tWsr7dMKPcA
// support my work - https://github.com/sponsors/bulgariamitko

Future<List<VideosRow>> updateAllRowsInTable(
  String? fieldName1,
  String? fieldName2,
  String? fieldName3,
  String? fieldValue1,
  int? fieldValue2,
  String? fieldValue3,
) async {
  // null check
  fieldName1 ??= 'error';
  fieldName2 ??= 'error';
  fieldName3 ??= 'error';
  fieldValue1 ??= 'error';
  fieldValue2 ??= 0;
  fieldValue3 ??= 'error';

  List<VideosRow> videos =
      await VideosTable().querySingleRow(queryFn: (q) => q);

  if (videos.length != 0) {
    List<VideosRow> returnedVideos = await VideosTable().update(
      data: {
        fieldName1: fieldValue1,
        fieldName2: fieldValue2,
        fieldName3: fieldValue3,
      },
      matchingRows: (row) => row.eq(
        'id',
        videos[0].id,
      ),
    );

    videos.addAll(returnedVideos);
  }

  return videos;
}