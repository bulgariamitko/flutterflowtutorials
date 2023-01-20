// code created by https://www.youtube.com/@flutterflowexpert

Future importFromCsvOrJson(BuildContext context, String? divider) async {
  // null safety check
  divider = divider ?? ',';

  // Get a reference to the Firestore database
  final firestore = FirebaseFirestore.instance;

  // TODO: Change collection name
  final collectionRef = firestore.collection('usersdata');

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

      print([1, rows]);

      for (var row in rows) {
        print([3, row]);

        // TODO: Chnage createUsersdataRecordData, FIELDS and KEYS
        doc = createUsersdataRecordData(
          username: row['Username'],
          identifier: row['Identifier'],
          onepass: row['One-time password'],
          recovery: row['Recovery code'],
          fname: row['First name'],
          lname: row['Last name'],
          departament: row['Department'],
          location: row['Location'],
        );

        await collectionRef.add(doc);
      }
    } else {
      rows = fileString.split('\n');

      int i = 0;
      for (var row in rows) {
        i++;

        print([2, row]);

        // skip the head fields
        if (i == 1) {
          continue;
        }

        List<String> fileds = row.split(divider);

        print([4, fileds]);

        // TODO: Chnage createUsersdataRecordData, FIELDS
        doc = createUsersdataRecordData(
          username: fileds[0],
          identifier: int.parse(fileds[1]),
          onepass: fileds[2],
          recovery: fileds[3],
          fname: fileds[4],
          lname: fileds[5],
          departament: fileds[6],
          location: fileds[7],
        );

        await collectionRef.add(doc);
      }
    }

    showUploadMessage(
      context,
      'Success!',
    );
  }
}