// code created by https://www.youtube.com/@flutterflowexpert

// Automatic FlutterFlow imports
import '../../backend/backend.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../actions/index.dart'; // Imports other custom actions
import '../../flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future batchUpdateOrInsertDocs(
  List<String>? field1,
  List<DateTime>? field2,
  List<String>? field3,
  String? collectionName,
  List<DocumentReference>? documentRef,
) async {
  // null check
  field1 = field1 ?? [];
  field2 = field2 ?? [];
  field3 = field3 ?? [];
  collectionName = collectionName ?? '';
  documentRef = documentRef ?? [];

  // Get a reference to the Firestore database
  final firestore = FirebaseFirestore.instance;

  // Get a reference to the collection
  final collectionRef = firestore.collection(collectionName);

  // Insert the new documents in the collection
  for (int i = 0; i < documentRef.length; i++) {
    // final doc = createWalletsRecordData(balance: field1[i]);
    final doc = createOrdersRecordData(
        name: field1[i], date: field2[i], orderid: field3[i]);

    // Check if a document with the given order ID already exists in the collection
    final docRef = collectionRef.doc(documentRef[i].id);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // Update the existing document with the new data
      await docRef.update(doc);
    } else {
      // Add a new document to the collection
      await collectionRef.add(doc);
    }
  }
}