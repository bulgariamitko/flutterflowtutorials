// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=z7psjaiWHC0

Future batchInsertDocs(
  List<String>? field1,
  List<DateTime>? field2,
  List<String>? field3,
  String? collectionName,
) async {
  // null check
  field1 = field1 ?? [];
  field2 = field2 ?? [];
  field3 = field3 ?? [];
  collectionName = collectionName ?? '';

  // Get a reference to the Firestore database
  final firestore = FirebaseFirestore.instance;

  // Get a reference to the collection
  final collectionRef = firestore.collection(collectionName);

  // Insert the new documents in the collection
  for (int i = 0; i < field1.length; i++) {
    // final doc = createWalletsRecordData(balance: field1[i]);
    final doc = createOrdersRecordData(
        name: field1[i], date: field2[i], orderid: field3[i]);

    await collectionRef.add(doc);
  }
}