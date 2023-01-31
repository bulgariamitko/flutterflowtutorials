// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=nHz5o78L0x0

Future updateOrInsertDocUsingFilter(
  String? field1,
  DateTime? field2,
  String? field3,
  String? collectionName,
) async {
  // null check
  field1 = field1 ?? '';
  field2 = field2 ?? DateTime.now();
  field3 = field3 ?? '';
  collectionName = collectionName ?? '';

  // Get a reference to the Firestore database
  final firestore = FirebaseFirestore.instance;

  // Get a reference to the collection
  final collectionRef = firestore.collection(collectionName);

  // TODO: change fields - name, date, orderid
  final doc =
      createOrdersRecordData(name: field1, date: field2, orderid: field3);

  // TODO: change fields you want to search for
  final docFilter =
      await collectionRef.where('orderid', isEqualTo: field3).get();

  if (docFilter.docs.isNotEmpty) {
    // Update the existing document with the new data
    await docFilter.docs.first.reference.update(doc);
  } else {
    // Add a new document to the collection
    await collectionRef.add(doc);
  }
}