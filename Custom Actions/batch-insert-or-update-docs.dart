// code created by https://www.youtube.com/@flutterflowexpert
// original video - https://www.youtube.com/watch?v=JyrYGzr-zyU
// update code video - https://youtube.com/watch?v=tWsr7dMKPcA
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

Future batchUpdateOrInsertDocs(
  String? fieldName1,
  String? fieldName2,
  String? fieldName3,
  List<String>? fieldValue1,
  List<DateTime>? fieldValue2,
  List<String>? fieldValue3,
  String? collectionName,
  List<DocumentReference>? documentRef,
) async {
  // null check
  fieldName1 ??= 'error';
  fieldName2 ??= 'error';
  fieldName3 ??= 'error';
  fieldValue1 = fieldValue1 ?? [];
  fieldValue2 = fieldValue2 ?? [];
  fieldValue3 = fieldValue3 ?? [];
  collectionName = collectionName ?? '';
  documentRef = documentRef ?? [];

  // Get a reference to the Firestore database
  final firestore = FirebaseFirestore.instance;

  // Get a reference to the collection
  final collectionRef = firestore.collection(collectionName);

  // Insert the new documents in the collection
  for (int i = 0; i < documentRef.length; i++) {
    // old code
    // final doc = createOrdersRecordData(name: field1[i], date: field2[i], orderid: field3[i]);

    // new code
    final doc = {
      fieldName1: fieldValue1[i],
      fieldName2: fieldValue2[i],
      fieldName3: fieldValue3[i],
    };

    // Check if a document with the given order ID already exists in the collection
    final docRef = collectionRef.doc(documentRef[i].id);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // Update the existing document with the new data
      await docRef.update(doc);
    } else {
      // Add a new document to the collection
      await collectionRef.add(doc);
    }
  }
}