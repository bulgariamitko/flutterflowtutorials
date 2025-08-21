// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - no
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

Future updateOrInsertDocUsingFilter(
  String? collectionName,
  DocumentReference userRef,
) async {
  // null check
  collectionName = collectionName ?? '';

  // Get a reference to the Firestore database
  final firestore = FirebaseFirestore.instance;

  // Get a reference to the collection
  final collectionRef = firestore.collection(collectionName);

  // Insert the new documents in the collection
  for (int i = 0; i < FFAppState().fieldName0.length; i++) {
    final doc = {
      'product_foto1': FFAppState().fieldName0[i] ?? '',
      'product_foto2': FFAppState().fieldName1[i] ?? '',
      'product_foto3': FFAppState().fieldName2[i] ?? '',
      'name': FFAppState().fieldName3[i] ?? '',
      'nroPieza': FFAppState().fieldName4[i] ?? '',
      'SKU': FFAppState().fieldName5[i] ?? '',
      'barcode': FFAppState().fieldName6[i] ?? '',
      'quantity': FFAppState().fieldName7[i] ?? '',
      'price': FFAppState().fieldName8[i] ?? '',
      'equivalencias': FFAppState().fieldName9[i] ?? '',
      'marcaProducto': FFAppState().fieldName10[i] ?? '',
      'modeloProducto': FFAppState().fieldName11[i] ?? '',
      'uid': userRef,
      'activa': true,
      'activa_byuser': false,
      'created_at': DateTime.now(),
    };

    // TODO: change fields you want to search for
    final docFilter = await collectionRef
        .where('SKU', isEqualTo: FFAppState().fieldName5[i])
        .where('uid', isEqualTo: userRef)
        .get();

    if (docFilter.docs.isNotEmpty) {
      // Update the existing document with the new data
      await docFilter.docs.first.reference.update(doc);
    } else {
      // Add a new document to the collection
      await collectionRef.add(doc);
    }
  }
}
