// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=1FKlfexT9Zw
// widgets - Cg9Db2x1bW5fa3lsY2xoMWoSxAIKD0J1dHRvbl9oZjYzZnFzdhgJIqwBSn0KKQoRRG93bmxvYWQgQ1NWIGZpbGU6Bgj/////D0AFegoSCDRsenNybjZuGQAAAAAAAABAKQAAAAAAAPB/MQAAAAAAAERASQAAAAAAAPA/UgIQAVoCCAByJAkAAAAAAAAgQBEAAAAAAAAgQBkAAAAAAAAgQCEAAAAAAAAgQFokCQAAAAAAACRAEQAAAAAAACRAGQAAAAAAACRAIQAAAAAAACRAegIYA/oDAGIAigF9EncKCHEyZ3d6ZWxrEhCqAgg1bTBpeGUwabIDAggDKlkKCDV0b3k3N282Ek3SAT8KIAoXZG93bmxvYWRDb2xsZWN0aW9uQXNDU1YSBTdmOHVwEhsSGQgEEhFTY2FmZm9sZF9wdTRnczAwbEICEgCqAgg1MGpqbGJyeRoCCAEYBCIFIgD6AwA=
// replace - [{"Collection name": "Cars"}, {"Field name 1": "name"}, {"Field name 2": "brand"}]
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
