// code created by https://www.youtube.com/@flutterflowexpert
// sb video - https://www.youtube.com/watch?v=z7psjaiWHC0
// sb update code video - https://youtube.com/watch?v=tWsr7dMKPcA
// support my work - https://github.com/sponsors/bulgariamitko

Future<List<VideosRow>> batchInsertRows(
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
    VideosRow video = await VideosTable().insert({
      fieldName1: fieldValue1[i],
      fieldName2: fieldValue2[i],
      fieldName3: fieldValue3[i],
    });

    videos.add(video);
  }

  return videos;
}
