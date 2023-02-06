// code created by https://www.youtube.com/@flutterflowexpert
// original video - https://www.youtube.com/watch?v=nHz5o78L0x0
// update code video - https://youtu.be/tWsr7dMKPcA
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

Future updateOrInsertDocUsingFilter(
  String? fieldName1,
  String? fieldName2,
  String? fieldName3,
  String? fieldValue1,
  DateTime? fieldValue2,
  String? fieldValue3,
  String? collectionName,
) async {
  // null check
  fieldName1 ??= 'error';
  fieldName2 ??= 'error';
  fieldName3 ??= 'error';
  fieldValue1 = fieldValue1 ?? '';
  fieldValue2 = fieldValue2 ?? DateTime.now();
  fieldValue3 = fieldValue3 ?? '';
  collectionName = collectionName ?? '';

  // Get a reference to the Firestore database
  final firestore = FirebaseFirestore.instance;

  // Get a reference to the collection
  final collectionRef = firestore.collection(collectionName);

  // old code
  // final doc = createOrdersRecordData(name: fieldValue1, date: fieldValue2, orderid: fieldValue3);

  // new code
  final doc = {
    fieldName1: fieldValue1,
    fieldName2: fieldValue2,
    fieldName3: fieldValue3,
  };

  // TODO: change fields you want to search for
  final docFilter =
      await collectionRef.where('orderid', isEqualTo: fieldValue3).get();

  if (docFilter.docs.isNotEmpty) {
    // Update the existing document with the new data
    await docFilter.docs.first.reference.update(doc);
  } else {
    // Add a new document to the collection
    await collectionRef.add(doc);
  }
}