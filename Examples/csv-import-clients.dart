// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - no
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'dart:io';

// import 'dart:convert' show utf8;
import 'dart:convert';
import 'package:csv/csv.dart';
// import '../../backend/firebase_storage/storage.dart';
// import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../flutter_flow/upload_data.dart';

Future getTitlesFromCSVFile(
  BuildContext context,
  String? divider,
  int? titleRow,
) async {
  // null safety check
  divider = divider ?? ',';
  // collectionName ??= 'users';
  // fieldName1 ??= 'error';
  // fieldName2 ??= 'error';
  // fieldName3 ??= 'error';
  // fieldName4 ??= 'error';
  // fieldName5 ??= 'error';
  titleRow ??= 0;

  // // Get a reference to the Firestore database
  // final firestore = FirebaseFirestore.instance;

  // // TODO: Change collection name
  // final collectionRef = firestore.collection(collectionName);

  final selectedFile = await selectFile(allowedExtensions: ['csv']);

  if (selectedFile != null) {
    showUploadMessage(context, 'Uploading file...', showLoading: true);

    final fileString = utf8.decode(selectedFile.bytes);

    List<String> rows = [];
    // String fileType = 'csv';
    // Map<String, dynamic> doc = {};
    // if file is json
    rows = fileString.split('\n');

    FFAppState().update(() {
      FFAppState().csvTitles = rows[(titleRow ?? 0) - 1].split(divider ?? ',');
      print([FFAppState().csvTitles]);
    });

    int i = 0;
    for (var row in rows) {
      i++;
      // skip the head fields
      if (i <= titleRow || i == rows.length - 2) {
        continue;
      }

      // print(['v4', row]);

      List<String> fields = row.split(divider);

      print(['Fields: ', fields.length, fields]); // Debugging line

      if (fields.length >= 12) {
        FFAppState().update(() {
          FFAppState().dumpFieldName0.add(fields[0]);
          FFAppState().dumpFieldName1.add(fields[1]);
          FFAppState().dumpFieldName2.add(fields[2]);
          FFAppState().dumpFieldName3.add(fields[3]);
          FFAppState().dumpFieldName4.add(fields[4]);
          FFAppState().dumpFieldName5.add(fields[5]);
          FFAppState().dumpFieldName6.add(fields[6]);
          FFAppState().dumpFieldName7.add(fields[7]);
          FFAppState().dumpFieldName8.add(fields[8]);
          FFAppState().dumpFieldName9.add(fields[9]);
          FFAppState().dumpFieldName10.add(fields[10]);
          FFAppState().dumpFieldName11.add(fields[11]);
        });
      }
    }

    showUploadMessage(context, 'Success!');
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the button on the right!

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the button on the right!
