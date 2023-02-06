// code created by https://www.youtube.com/@flutterflowexpert
// original video - https://www.youtube.com/watch?v=z7psjaiWHC0
// update code video - https://youtu.be/tWsr7dMKPcA
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

Future batchInsertDocs(
  String? fieldName1,
  String? fieldName2,
  String? fieldName3,
  List<String>? fieldValue1,
  List<DateTime>? fieldValue2,
  List<String>? fieldValue3,
  String? collectionName,
) async {
  // null check
  fieldName1 ??= 'error';
  fieldName2 ??= 'error';
  fieldName3 ??= 'error';
  fieldValue1 = fieldValue1 ?? [];
  fieldValue2 = fieldValue2 ?? [];
  fieldValue3 = fieldValue3 ?? [];
  collectionName = collectionName ?? '';

  // Get a reference to the Firestore database
  final firestore = FirebaseFirestore.instance;

  // Get a reference to the collection
  final collectionRef = firestore.collection(collectionName);

  // Insert the new documents in the collection
  for (int i = 0; i < fieldValue1.length; i++) {
    // old code
    // final doc = createOrdersRecordData(
    //     name: fieldValue1[i], date: fieldValue2[i], orderid: fieldValue3[i]);
    // await collectionRef.add(doc);

    // new code
    await collectionRef.add({
      fieldName1: fieldValue1[i],
      fieldName2: fieldValue2[i],
      fieldName3: fieldValue3[i],
    });
  }
}