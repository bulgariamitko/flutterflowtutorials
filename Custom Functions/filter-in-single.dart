// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=I9zSyJccwa0
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

List<PostsRecord>? filterINdocs(
  List<UsersdataRecord>? users,
  List<PostsRecord>? posts,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // null safety
  users ??= [];
  posts ??= [];

  List<PostsRecord> filteredPosts = posts.where((postDoc) {
    // TODO change field "follow" to your own field
    bool hasUserFollowing =
        users!.any((user) => user.reference == postDoc.follow);
    return hasUserFollowing;
  }).toList();

  return filteredPosts;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
