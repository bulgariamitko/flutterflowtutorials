// code created by https://www.youtube.com/@flutterflowexpert
// video - no
// support my work - https://github.com/sponsors/bulgariamitko

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
