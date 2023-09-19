// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

import 'package:csv/csv.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../flutter_flow/upload_data.dart';

Future importFromCsvOrJson(
  BuildContext context,
  String? divider,
  String? tableName,
  String? fieldName1,
  String? fieldName2,
  String? fieldName3,
  String? fieldName4,
  String? fieldName5,
) async {
  // null safety check
  divider = divider ?? ',';
  tableName ??= 'users';
  fieldName1 ??= 'error';
  fieldName2 ??= 'error';
  fieldName3 ??= 'error';
  fieldName4 ??= 'error';
  fieldName5 ??= 'error';

  // Initialize Supabase client
  final client = SupaFlow.client;

  final selectedFile = await selectFile(allowedExtensions: ['csv', 'json']);

  if (selectedFile != null) {
    showUploadMessage(context, 'Uploading file...', showLoading: true);

    final fileString = selectedFile.readAsBytesSync().toString();

    List<String> rows = [];
    String fileType = 'csv';
    Map<String, dynamic> doc = {};
    // if file is json
    if (selectedFile.path.contains('json')) {
      fileType = 'json';
      List<dynamic> rows = jsonDecode(fileString);

      for (var row in rows) {
        bool accessBlock = row['My Bool'] == 'TRUE';
        final dateFormat = DateFormat("yyyy/MM/dd HH:mm:ss");
        DateTime createdTime = dateFormat.parse(row['My DateTime']);

        final response = await client.from(tableName).insert({
          fieldName1: row['Username'],
          fieldName2: row['Identifier'],
          fieldName3: accessBlock,
          fieldName4: createdTime.toIso8601String(),
          fieldName5: row['My Ref'],
        });

        if (response.error != null) {
          print(response.error!.message);
        }
      }
    } else {
      rows = fileString.split('\n');
      int i = 0;

      for (var row in rows) {
        i++;
        if (i == 1) {
          continue;
        }

        List<String> fields = row.split(divider);
        bool accessBlock = fields[2] == 'TRUE';
        final dateFormat = DateFormat("yyyy/MM/dd HH:mm:ss");
        DateTime createdTime = dateFormat.parse(fields[3]);

        final response = await client.from(tableName).insert({
          fieldName1: fields[0],
          fieldName2: int.parse(fields[1]),
          fieldName3: accessBlock,
          fieldName4: fields[3].isEmpty ? null : createdTime.toIso8601String(),
          fieldName5: fields[4],
        });

        if (response.error != null) {
          print(response.error!.message);
        }
      }
    }

    showUploadMessage(context, 'Success!');
  }
}
