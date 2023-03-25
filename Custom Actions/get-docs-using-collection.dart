// code created by https://www.youtube.com/@flutterflowexpert
// video - https://youtu.be/Lt0irFF_NpE
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

// TODO change the name of the collection from CarsRecord to yuor collection, lets say UsersRecord
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