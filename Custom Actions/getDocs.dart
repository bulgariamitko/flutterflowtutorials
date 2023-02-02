// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=HtvtwLmaI0w
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

Future<List<CarsRecord>> getDocs(List<DocumentReference> docRefs) async {
  List<CarsRecord> docs = [];

  // Iterate through the list of document references
  for (var docRef in docRefs) {
    // Get the document from the specified collection
    CarsRecord docToAdd = await CarsRecord.getDocumentOnce(docRef);

    // Add the document to the list
    docs.add(docToAdd);

    // Add Doc to Local State
    // FFAppState().update(() {
    // FFAppState().brandNames.add(docToAdd.brand ?? '');
    // });
  }

  return docs;
}