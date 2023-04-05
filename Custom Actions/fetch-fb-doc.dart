// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=HtvtwLmaI0w
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

Future<ReloadScreenRecord> getDoc(DocumentReference docRef) async {
  return ReloadScreenRecord.getDocumentOnce(docRef);
}