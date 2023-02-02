// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=nHz5o78L0x0
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

Future updateOrInsertDoc(
  String? field1,
  DateTime? field2,
  String? field3,
  String? collectionName,
  DocumentReference? documentRef,
) async {
  // null check
  field1 = field1 ?? '';
  field2 = field2 ?? DateTime.now();
  field3 = field3 ?? '';
  collectionName = collectionName ?? '';
  documentRef = documentRef ??
      FirebaseFirestore.instance.doc('/orders/ILiVSV2hnKOkzviPV7rr');

  // Get a reference to the Firestore database
  final firestore = FirebaseFirestore.instance;

  // Get a reference to the collection
  final collectionRef = firestore.collection(collectionName);

  // final doc = createWalletsRecordData(balance: field1[i]);
  final doc =
      createOrdersRecordData(name: field1, date: field2, orderid: field3);

  // Check if a document with the given order ID already exists in the collection
  final docRef = collectionRef.doc(documentRef.id);
  final docSnapshot = await docRef.get();

  if (docSnapshot.exists) {
    // Update the existing document with the new data
    await docRef.update(doc);
  } else {
    // Add a new document to the collection
    await collectionRef.add(doc);
  }
}