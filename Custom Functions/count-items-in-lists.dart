// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

int? newNoticeCount(
  List<String>? recipientList,
  List<String>? readerList,
  String? uid,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  var uidDocumentsInRecipientList =
      recipientList?.where((doc) => doc.contains(uid ?? ''));
  var uidDocumentsInReaderList =
      readerList?.where((doc) => doc.contains(uid ?? ''));

  // count the number of documents in each list and return the sum
  var count1 = uidDocumentsInRecipientList?.length ?? 0;
  var count2 = uidDocumentsInReaderList?.length ?? 0;
  return count1 + count2;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
