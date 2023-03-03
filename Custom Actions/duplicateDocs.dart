// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=1FKlfexT9Zw
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

Future<void> duplicateDocuments(
    String? collectionName, List<DocumentReference>? documentIds) async {
  // null safety
  collectionName ??= 'users';
  documentIds ??= [];

  final batch = FirebaseFirestore.instance.batch();

  // Query for the documents to be duplicated
  final querySnapshot = await FirebaseFirestore.instance
      .collection(collectionName)
      .where(FieldPath.documentId,
          whereIn: documentIds.map((docRef) => docRef.id).toList())
      .get();

  // Create a new document for each of the documents to be duplicated
  for (final doc in querySnapshot.docs) {
    batch.set(FirebaseFirestore.instance.collection(collectionName).doc(),
        doc.data());
  }

  // Commit the batch
  await batch.commit();
}