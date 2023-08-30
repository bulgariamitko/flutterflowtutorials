// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=HtvtwLmaI0w
// widgets - Cg9Db2x1bW5fdmZ3aGF4YjgSYQoNVGV4dF94ajhtNTcyMhgCIkwSJwoLSGVsbG8gV29ybGQRAAAAAAAANkBABnoKEghpc2w3eDhtOagBAJoBHQoCAgEqFwgGEg9Db2x1bW5fdmZ3aGF4YjhCAioA+gMAYgAYBCIFIgD6AwBqIQoHCgVicmFuZBIWCAxCEiIQCgwKCmJyYW5kTmFtZXMQAQ==
// replace - [{"Collection name": "Cars"}]
// support my work - https://github.com/sponsors/bulgariamitko

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