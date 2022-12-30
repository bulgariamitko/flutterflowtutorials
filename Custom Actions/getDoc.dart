// code created by https://www.youtube.com/@flutterflowexpert

Future<CarsRecord> getDoc(DocumentReference docRef) async {
  return CarsRecord.getDocumentOnce(docRef);
}
