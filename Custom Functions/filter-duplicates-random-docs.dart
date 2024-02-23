// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

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
