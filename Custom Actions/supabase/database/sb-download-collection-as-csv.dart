// code created by https://www.youtube.com/@flutterflowexpert
// sb video - https://www.youtube.com/watch?v=1FKlfexT9Zw
// support my work - https://github.com/sponsors/bulgariamitko

import 'dart:convert' show utf8;
import 'package:download/download.dart';

Future downloadCollectionAsCSVSB(List<ViewersRow>? docs) async {
  // null check
  docs = docs ?? [];

  // Add the company name and address as a header
  String viewerId = "ID";
  String viewerName = "Name";
  String viewerDate = "Date";
  String header = "$viewerId,$viewerName,$viewerDate\n\n";

  String fileContent = header;

  docs.asMap().forEach((index, record) => fileContent += "\n" +
      record.id.toString() +
      "," +
      record.name.toString() +
      "," +
      DateFormat('dd-MM-yyyy HH:mm')
          .format(record.createdAt ?? DateTime.now()));

  final fileName = "FF" + DateTime.now().toString() + ".csv";

  // Encode the string as a List<int> of UTF-8 bytes
  var bytes = utf8.encode(fileContent);

  final stream = Stream.fromIterable(bytes);
  return download(stream, fileName);
}
