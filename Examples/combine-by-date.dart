// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - no
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

List<dynamic> combineVideosByDate(List<VideoStruct>? videos) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  Map<DateTime, List<VideoStruct>> groupedVideos = {};

  videos?.forEach((video) {
    DateTime date = DateTime(
      video.date!.year,
      video.date!.month,
      video.date!.day,
    );
    if (!groupedVideos.containsKey(date)) {
      groupedVideos[date] = [];
    }
    groupedVideos[date]?.add(video);
  });

  List<Map<String, dynamic>> videosByDate = [];
  groupedVideos.forEach((date, videos) {
    videosByDate.add({
      'date': date.toIso8601String().split('T').first,
      'videos': videos
          .map(
            (v) => {
              'name': v.name,
              'path': v.path,
              'date': v.date!.toIso8601String(),
              'merged': v.merged,
            },
          )
          .toList(),
    });
  });

  return videosByDate;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
