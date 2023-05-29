// code created by https://www.youtube.com/@flutterflowexpert
// video - no
// support my work - https://github.com/sponsors/bulgariamitko

UsersRecord? shuffleUsers(List<UsersRecord>? allUsers) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // remove docs duplicats based on the email field and retun a random doc

  // null safety
  allUsers ??= [];

  // Using a Map to store unique users by their email.
  final uniqueUsersMap = <String, UsersRecord>{};

  for (var user in allUsers) {
    if (user.winner == false) {
      uniqueUsersMap[user.email] = user;
    }
  }

  // Convert the Map back to a List.
  final uniqueUsers = uniqueUsersMap.values.toList();

  // random index
  int randomIndex = math.Random().nextInt(uniqueUsers.length);

  return uniqueUsers[randomIndex];

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
