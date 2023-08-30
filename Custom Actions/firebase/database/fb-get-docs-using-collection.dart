// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://youtube.com/watch?v=Lt0irFF_NpE
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

// IMPORTANT you no longer need to use this custom code, more info - https://www.youtube.com/watch?v=yGggMqY0peY

// TODO change the name of the collection from CarsRecord to your collection, lets say UsersRecord
Future<List<CarsRecord>> getDocsFromCollection(
  String? collectionName,
  int? limit,
) async {
  // null safety
  collectionName ??= 'car';
  limit ??= -1;

  // TODO change the name here
  List<CarsRecord> docs = [];

  // Get a reference to the Firestore database
  final firestore = FirebaseFirestore.instance;

  // Get a reference to the usersdata collection
  final collectionRef = firestore.collection(collectionName);

  // Fetch all documents from the usersdata collection
  Query query = collectionRef;

  // Apply the limit if specified
  if (limit > 0) {
    query = query.limit(limit);
  }

  final querySnapshot = await query.get();

  // Iterate through the documents and create CarsRecord instances
  for (var doc in querySnapshot.docs) {
    // TODO 2 x with capipital letter and 1 x lower letter
    CarsRecord carsRecord = await CarsRecord.getDocumentOnce(doc.reference);
    // TODO 1 x lower letter
    docs.add(carsRecord);
  }

  return docs;
}