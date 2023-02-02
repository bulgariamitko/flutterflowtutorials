// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=nHz5o78L0x0
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

Future updateAllDocsInCollection(
  String? fieldName,
  String? fieldValue,
  String? collectionName,
) async {
  // null check
  fieldName ??= '';
  fieldValue ??= '';
  collectionName ??= '';

  // Get a reference to the Firestore database
  final firestore = FirebaseFirestore.instance;

  // Get a reference to the collection
  final collectionRef = firestore.collection(collectionName);

  // Get a reference to all documents in the collection
  final querySnapshot = await collectionRef.get();

  // Iterate over the documents in the collection
  for (var i = 0; i < querySnapshot.docs.length; i++) {
    // Get a reference to the current document
    final docRef = querySnapshot.docs[i].reference;

    // Update the "name" field of the document with the corresponding value from fieldValue
    await docRef.update({
      fieldName: fieldValue,
    });
  }
}