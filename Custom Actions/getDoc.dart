// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=HtvtwLmaI0w

Future<CarsRecord> getDoc(DocumentReference docRef) async {
  return CarsRecord.getDocumentOnce(docRef);
}
