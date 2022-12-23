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

Future batchInsertDocs(
  List<String>? field1,
  List<DateTime>? field2,
  List<String>? field3,
  String? collectionName,
) async {
  // null check
  field1 = field1 ?? [];
  field2 = field2 ?? [];
  field3 = field3 ?? [];
  collectionName = collectionName ?? '';

  // Get a reference to the Firestore database
  final firestore = FirebaseFirestore.instance;

  // Get a reference to the collection
  final collectionRef = firestore.collection(collectionName);

  // Insert the new documents in the collection
  for (int i = 0; i < field1.length; i++) {
    // final doc = createWalletsRecordData(balance: field1[i]);
    final doc = createOrdersRecordData(
        name: field1[i], date: field2[i], orderid: field3[i]);

    await collectionRef.add(doc);
  }
}