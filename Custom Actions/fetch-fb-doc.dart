// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=HtvtwLmaI0w

Future<ReloadScreenRecord> getDoc(DocumentReference docRef) async {
  return ReloadScreenRecord.getDocumentOnce(docRef);
}