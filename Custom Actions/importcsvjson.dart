// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=4Ir1j6L48Lg
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

import 'dart:io';
import 'package:intl/intl.dart';

// import 'dart:convert' show utf8;
import 'dart:convert';
import 'package:csv/csv.dart';
import '../../backend/firebase_storage/storage.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../flutter_flow/upload_media.dart';

Future importFromCsvOrJson(
  BuildContext context,
  String? divider,
  String? collectionName,
  String? fieldName1,
  String? fieldName2,
  String? fieldName3,
  String? fieldName4,
  String? fieldName5,
) async {
  // null safety check
  divider = divider ?? ',';
  collectionName ??= 'users';
  fieldName1 ??= 'error';
  fieldName2 ??= 'error';
  fieldName3 ??= 'error';
  fieldName4 ??= 'error';
  fieldName5 ??= 'error';

  // Get a reference to the Firestore database
  final firestore = FirebaseFirestore.instance;

  // TODO: Change collection name
  final collectionRef = firestore.collection(collectionName);

  final selectedFile = await selectFile(allowedExtensions: ['csv', 'json']);

  if (selectedFile != null) {
    showUploadMessage(
      context,
      'Uploading file...',
      showLoading: true,
    );

    final fileString = utf8.decode(selectedFile.bytes);

    List<String> rows = [];
    String fileType = 'csv';
    Map<String, dynamic> doc = {};
    // if file is json
    if (selectedFile.storagePath.contains('json')) {
      fileType = 'json';
      List<dynamic> rows = jsonDecode(fileString);

      for (var row in rows) {
        // Convert the `Access_Block` field to a boolean
        bool accessBlock = row['My Bool'] == 'TRUE';

        // Convert the `CreatedTime` field to a DateTime object
        final dateFormat = DateFormat("yyyy/MM/dd HH:mm:ss");
        DateTime createdTime = dateFormat.parse(row['My DateTime']);

        // Get a reference to the `docRef` document
        DocumentReference docRef = firestore.doc(row['My Ref']);

        // old code
        // doc = createUsersdataRecordData(
        //   username: row['Username'],
        //   identifier: row['Identifier'],
        //   onepass: row['One-time password'],
        //   recovery: row['Recovery code'],
        //   fname: row['First name'],
        //   lname: row['Last name'],
        //   departament: row['Department'],
        //   location: row['Location'],
        //   myBool: accessBlock,
        //   myDate: createdTime,
        //   myRef: docRef,
        // );
        // await collectionRef.add(doc);

        // new code
        await collectionRef.add({
          fieldName1: row['Username'],
          fieldName2: row['Identifier'],
          fieldName3: accessBlock,
          fieldName4: createdTime,
          fieldName5: docRef,
        });
      }
    } else {
      rows = fileString.split('\n');

      int i = 0;
      for (var row in rows) {
        i++;

        // skip the head fields
        if (i == 1) {
          continue;
        }

        List<String> fields = row.split(divider);

        // Convert the `Access_Block` field to a boolean
        bool accessBlock = fields[2] == 'TRUE';

        // Convert the `CreatedTime` field to a DateTime object
        final dateFormat = DateFormat("yyyy/MM/dd HH:mm:ss");
        DateTime createdTime = dateFormat.parse(fields[3]);

        // Get a reference to the `docRef` document
        DocumentReference docRef = firestore.doc(fields[4]);

        // old code
        // doc = createUsersdataRecordData(
        //   username: fields[0],
        //   identifier: int.parse(fields[1]),
        //   onepass: fields[2],
        //   recovery: fields[3],
        //   fname: fields[4],
        //   lname: fields[5],
        //   departament: fields[6],
        //   location: fields[7],
        // );
        // await collectionRef.add(doc);

        // new code
        await collectionRef.add({
          fieldName1: fields[0],
          fieldName2: int.parse(fields[1]),
          fieldName3: accessBlock,
          fieldName4: createdTime,
          fieldName5: docRef,
        });
      }
    }

    showUploadMessage(
      context,
      'Success!',
    );
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the button on the right!