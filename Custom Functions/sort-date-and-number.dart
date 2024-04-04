// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

List<UsersdataRecord> sortDateAndThenIdentifier(
    List<UsersdataRecord> usersdata) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  usersdata.sort((a, b) {
    int compareDate = DateTime(a.myDate!.year, a.myDate!.month, a.myDate!.day)
        .compareTo(DateTime(b.myDate!.year, b.myDate!.month, b.myDate!.day));
    if (compareDate != 0) return compareDate;
    return a.identifier.compareTo(b.identifier);
  });

  // print(usersdata);
  // List<int> result = [];
  // usersdata.forEach((item) {
  //   result.add(item.identifier);
  //   print(item.identifier);
  // });

  return usersdata;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
