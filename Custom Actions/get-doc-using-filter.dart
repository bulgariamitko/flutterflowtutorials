// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=nHz5o78L0x0
// update code video - https://youtube.com/watch?v=tWsr7dMKPcA
// replace - [{"Collection name": "Cars"}, {"Collection path in Firebase": "/cars/"}]
// support my work - https://github.com/sponsors/bulgariamitko

Future<CarsRecord> getDocUsingFilter(
  String? fieldSearch,
  String? fieldValue,
  String? collectionName,
) async {
  // null check
  fieldSearch ??= 'error';
  fieldValue = fieldValue ?? '';
  collectionName = collectionName ?? '';
  DocumentReference userRef =
      FirebaseFirestore.instance.doc('/users/' + fieldValue);

  // Create backup document
  final data = createCarsRecordData(
    userRef: FirebaseFirestore.instance.doc('/cars/123'),
  );
  final docRef =
      FirebaseFirestore.instance.collection('Cars').doc('randomID');
  CarsRecord doc = CarsRecord.getDocumentFromData(data, docRef);

  // Get a reference to the Firestore database
  final firestore = FirebaseFirestore.instance;

  // Get a reference to the collection
  final collectionRef = firestore.collection(collectionName);

  // Get the documents
  final querySnapshot =
      await collectionRef.where(fieldSearch, isEqualTo: userRef).get();

  // Return the first document if available, else return null
  CarsRecord response = querySnapshot.docs.isNotEmpty
      ? CarsRecord.fromSnapshot(querySnapshot.docs[0])
      : doc;

  return response;
}
