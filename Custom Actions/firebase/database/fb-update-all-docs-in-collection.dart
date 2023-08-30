// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=nHz5o78L0x0
// update code video - https://youtube.com/watch?v=tWsr7dMKPcA
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

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