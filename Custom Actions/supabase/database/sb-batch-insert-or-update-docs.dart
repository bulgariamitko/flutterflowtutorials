// code created by https://www.youtube.com/@flutterflowexpert
// sb video - https://www.youtube.com/watch?v=JyrYGzr-zyU
// sb update code video - https://youtube.com/watch?v=tWsr7dMKPcA
// support my work - https://github.com/sponsors/bulgariamitko

Future<List<VideosRow>> batchInsertOrUpdateRows(
  String? fieldName1,
  String? fieldName2,
  String? fieldName3,
  List<String>? fieldValue1,
  List<int>? fieldValue2,
  List<String>? fieldValue3,
) async {
  // null check
  fieldName1 ??= 'error';
  fieldName2 ??= 'error';
  fieldName3 ??= 'error';
  fieldValue1 ??= [];
  fieldValue2 ??= [];
  fieldValue3 ??= [];

  List<VideosRow> videos = [];

  for (int i = 0; i < fieldValue1.length; i++) {
    videos = await VideosTable().queryRows(
      queryFn: (q) => q
          .eq(
            fieldName1 ?? '',
            fieldValue1?[i],
          )
          .eq(
            fieldName2 ?? '',
            fieldValue2?[i],
          )
          .eq(
            fieldName3 ?? '',
            fieldValue3?[i],
          ),
    );

    if (videos.length != 0) {
      for (int y = 0; y < videos.length; y++) {
        List<VideosRow> returnedVideos = await VideosTable().update(
          data: {
            fieldName1: fieldValue1[i],
            fieldName2: fieldValue2[i],
            fieldName3: fieldValue3[i],
          },
          matchingRows: (row) => row.eq(
            'id',
            videos[y].id,
          ),
        );

        videos.addAll(returnedVideos);
      }
    } else {
      VideosRow video = await VideosTable().insert({
        fieldName1: fieldValue1[i],
        fieldName2: fieldValue2[i],
        fieldName3: fieldValue3[i],
      });

      videos.add(video);
    }
  }

  return videos;
}
