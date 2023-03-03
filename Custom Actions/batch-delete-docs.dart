// code created by https://www.youtube.com/@flutterflowexpert
// video - https://youtu.be/IwhSbx1yN1M?t=3513
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

Future batchDelete(String? collectionName) async {
  collectionName = collectionName ?? '';

  // Get a reference to the Firestore database
  final firestore = FirebaseFirestore.instance;

  // Get a reference to the collection
  final collectionRef = firestore.collection(collectionName);

  // Get a list of all the documents in the collection
  final QuerySnapshot snapshot = await collectionRef.get();

  // Delete each document in the collection
  snapshot.docs.forEach((document) async {
    await document.reference.delete();
  });
}