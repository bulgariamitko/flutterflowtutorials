// code created by https://www.youtube.com/@flutterflowexpert
// original video - https://www.youtube.com/watch?v=JyrYGzr-zyU
// update code video - https://youtube.com/watch?v=tWsr7dMKPcA
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

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