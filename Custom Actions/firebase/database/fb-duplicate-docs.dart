// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://youtube.com/watch?v=sCS3MfRuEUY
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

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