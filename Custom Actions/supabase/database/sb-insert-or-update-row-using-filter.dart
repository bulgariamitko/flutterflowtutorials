// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=0_TIH7xT5_Y&t=1s
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

Future<VideosRow> insertOrUpdateRow(
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

  List<VideosRow> videos = await VideosTable().querySingleRow(
    queryFn: (q) => q
        .eq(
          fieldName1 ?? '',
          fieldValue1,
        )
        .eq(
          fieldName2 ?? '',
          fieldValue2,
        )
        .eq(
          fieldName3 ?? '',
          fieldValue3,
        ),
  );

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
  } else {
    VideosRow video = await VideosTable().insert({
      fieldName1: fieldValue1,
      fieldName2: fieldValue2,
      fieldName3: fieldValue3,
    });

    videos.add(video);
  }

  return videos[0];
}