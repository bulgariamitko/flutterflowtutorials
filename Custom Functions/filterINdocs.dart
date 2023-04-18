// code created by https://www.youtube.com/@flutterflowexpert
// original video - https://www.youtube.com/watch?v=JyrYGzr-zyU
// update code video - https://youtube.com/watch?v=tWsr7dMKPcA
// support my work - https://github.com/sponsors/bulgariamitko

List<PostsRecord>? filterINdocsFollowing(
  List<UsersdataRecord>? users,
  List<PostsRecord>? posts,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

// null safety
  users ??= [];
  posts ??= [];

  List<PostsRecord> filteredPosts = posts.where((postDoc) {
    // TODO change field "following" to your own field
    bool hasUserFollowing = postDoc.following!.any((postFollowerRef) {
      return users!.any((user) => user.reference == postFollowerRef);
    });
    return hasUserFollowing;
  }).toList();

  return filteredPosts;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}