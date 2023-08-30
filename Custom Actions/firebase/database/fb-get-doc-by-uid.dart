// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=HtvtwLmaI0w
// replace - [{"Collection name": "Cars"}]
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

// IMPORTANT you no longer need to use this custom code, more info - https://www.youtube.com/watch?v=yGggMqY0peY

Future<CarsRecord> getDoc(DocumentReference docRef) async {
  return CarsRecord.getDocumentOnce(docRef);
}

Future<CarsRecord?> checkIfDocExists(String? docId, String? collectionName) async {
  // null safety
  docId ??= 'df43freevrv4';
  collectionName ??= 'users';

  // Add your function code here!
  final firestoreInstance = FirebaseFirestore.instance;

	final documentSnapshot = await firestoreInstance.collection(collectionName).doc(docId).get();

	  final documentData = documentSnapshot.data()!;
	  final reference = documentSnapshot.reference;
	  final doc = CarsRecord.getDocumentFromData(documentData, reference);
	  return doc;
}