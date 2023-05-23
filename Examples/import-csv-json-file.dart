// code created by https://www.youtube.com/@flutterflowexpert
// video - no
// support my work - https://github.com/sponsors/bulgariamitko

import 'dart:convert';
import 'package:csv/csv.dart';
import '../../backend/firebase_storage/storage.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../flutter_flow/upload_data.dart';

Future importFromCsvOrJson(
  BuildContext context,
  String? divider,
  String? collectionName,
  String? fieldName1,
  String? fieldName2,
  String? fieldName3,
  String? fieldName4,
  String? fieldName5,
  String? fieldName6,
  String? fieldName7,
  String? fieldName8,
  String? fieldName9,
  String? fieldName10,
  String? fieldName11,
  DocumentReference? hotelRef,
) async {
  // null safety check
  divider = divider ?? ',';
  collectionName ??= 'users';
  fieldName1 ??= 'error';
  fieldName2 ??= 'error';
  fieldName3 ??= 'error';
  fieldName4 ??= 'error';
  fieldName5 ??= 'error';
  fieldName6 ??= 'error';
  fieldName7 ??= 'error';
  fieldName8 ??= 'error';
  fieldName9 ??= 'error';
  fieldName10 ??= 'error';
  fieldName11 ??= 'error';
  hotelRef ??= FirebaseFirestore.instance.doc('/Hotel/exNu4mnK9GAtZGGG7jYf');
  DocumentReference houseRef =
      FirebaseFirestore.instance.doc('/House/3VCdIroGPemdrqNnFupj');
  DocumentReference villaRef =
      FirebaseFirestore.instance.doc('/Villa/QK3FEFrbO7oHqLDGZGNF');

  HotelRecord backupHotel = await HotelRecord.getDocumentOnce(hotelRef);
  HouseRecord backupHouse = await HouseRecord.getDocumentOnce(houseRef);
  VillaRecord backupVilla = await VillaRecord.getDocumentOnce(villaRef);
  ;
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
        // bool accessBlock = fields[2] == 'TRUE';

        // Convert the `CreatedTime` field to a DateTime object
        final dateFormat = DateFormat("dd/MM/yyyy");
        DateTime createdTime = dateFormat.parse(fields[4]);

        // find the House
        final collectionHouseRef = firestore.collection('House');
        final houseDocs = await collectionHouseRef
            .where('Nombre', isEqualTo: fields[8])
            .where('Hotel', isEqualTo: hotelRef)
            .get();
        HouseRecord houseDoc = await houseDocs.docs.isNotEmpty
            ? houseDocs.docs[0] as HouseRecord
            : backupHouse;

        // find the Villa
        final collectionVillaRef = firestore.collection('Villa');
        final villaDocs = await collectionVillaRef
            .where('Nombre', isEqualTo: fields[7])
            .where('House', isEqualTo: houseDoc.reference)
            .get();
        VillaRecord villaDoc = villaDocs.docs.isNotEmpty
            ? villaDocs.docs[0] as VillaRecord
            : backupVilla;

        // find the Hotel
        final collectionHotelRef = firestore.collection('Hotel');
        final querySnapshot = await collectionHotelRef
            .where('Nombre', isEqualTo: fields[9])
            .get();
        HotelRecord hotelDoc = await querySnapshot.docs.isNotEmpty
            ? querySnapshot.docs[0] as HotelRecord
            : backupHotel;

        // new code
        await collectionRef.add({
          fieldName1: fields[0],
          fieldName2: fields[1],
          fieldName3: [],
          fieldName4: createdTime,
          fieldName5: fields[4],
          fieldName6: fields[5],
          fieldName7: villaDoc.reference,
          fieldName8: houseDoc.reference,
          fieldName9: hotelDoc.reference,
          fieldName10: [],
          fieldName11: fields[10],
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