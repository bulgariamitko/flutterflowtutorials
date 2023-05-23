// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=nHz5o78L0x0
// update code video - https://youtube.com/watch?v=tWsr7dMKPcA
// support my work - https://github.com/sponsors/bulgariamitko

Future<SpotifyRecord> getDocUsingFilter(
  String? fieldSearch,
  String? fieldValue,
  String? collectionName,
) async {
  // null check
  fieldSearch ??= 'error';
  fieldValue = fieldValue ?? '';
  collectionName = collectionName ?? '';
  SpotifyRecord spotifyRec = createSpotifyRecordData(
      userRef: FirebaseFirestore.instance.doc('/spotify/123')) as SpotifyRecord;

  // Get a reference to the Firestore database
  final firestore = FirebaseFirestore.instance;

  // Get a reference to the collection
  final collectionRef = firestore.collection(collectionName);

  // Get the documents
  final querySnapshot =
      await collectionRef.where(fieldSearch, isEqualTo: fieldValue).get();

  // Return the first document if available, else return null
  return querySnapshot.docs.isNotEmpty
      ? querySnapshot.docs[0] as SpotifyRecord
      : spotifyRec;
}
