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

Future updateOrInsertDoc(
  String? field1,
  DateTime? field2,
  String? field3,
  String? collectionName,
  DocumentReference? documentRef,
) async {
  // null check
  field1 = field1 ?? '';
  field2 = field2 ?? DateTime.now();
  field3 = field3 ?? '';
  collectionName = collectionName ?? '';
  documentRef = documentRef ??
      FirebaseFirestore.instance.doc('/orders/ILiVSV2hnKOkzviPV7rr');

  // Get a reference to the Firestore database
  final firestore = FirebaseFirestore.instance;

  // Get a reference to the collection
  final collectionRef = firestore.collection(collectionName);

  // final doc = createWalletsRecordData(balance: field1[i]);
  final doc =
      createOrdersRecordData(name: field1, date: field2, orderid: field3);

  // Check if a document with the given order ID already exists in the collection
  final docRef = collectionRef.doc(documentRef.id);
  final docSnapshot = await docRef.get();

  if (docSnapshot.exists) {
    // Update the existing document with the new data
    await docRef.update(doc);
  } else {
    // Add a new document to the collection
    await collectionRef.add(doc);
  }
}