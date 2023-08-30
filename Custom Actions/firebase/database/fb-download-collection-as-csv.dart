// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=1FKlfexT9Zw
// widgets - Cg9Db2x1bW5fa3lsY2xoMWoSxAIKD0J1dHRvbl9oZjYzZnFzdhgJIqwBSn0KKQoRRG93bmxvYWQgQ1NWIGZpbGU6Bgj/////D0AFegoSCDRsenNybjZuGQAAAAAAAABAKQAAAAAAAPB/MQAAAAAAAERASQAAAAAAAPA/UgIQAVoCCAByJAkAAAAAAAAgQBEAAAAAAAAgQBkAAAAAAAAgQCEAAAAAAAAgQFokCQAAAAAAACRAEQAAAAAAACRAGQAAAAAAACRAIQAAAAAAACRAegIYA/oDAGIAigF9EncKCHEyZ3d6ZWxrEhCqAgg1bTBpeGUwabIDAggDKlkKCDV0b3k3N282Ek3SAT8KIAoXZG93bmxvYWRDb2xsZWN0aW9uQXNDU1YSBTdmOHVwEhsSGQgEEhFTY2FmZm9sZF9wdTRnczAwbEICEgCqAgg1MGpqbGJyeRoCCAEYBCIFIgD6AwA=
// replace - [{"Collection name": "Cars"}, {"Field name 1": "name"}, {"Field name 2": "brand"}]
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

import 'dart:convert' show utf8;
import 'package:download/download.dart';

Future downloadCollectionAsCSV(List<CarsRecord>? docs) async {
  docs = docs ?? [];

  // Add the company name and address as a header
  String companyName = "Your Company Name";
  String companyAddress = "Your Company Address";
  String header = "$companyName,$companyAddress\n\n";

  String fileContent = header + "name, brand";

  docs.asMap().forEach((index, record) => fileContent = fileContent +
      "\n" +
      record.name.toString() +
      "," +
      record.brand.toString());

  // Example of date formating thanks to Edmund Ong
  // DateFormat('dd-MM-yyyy').format(record.attendanceDate!) +
  //     "," +
  //     DateFormat('HH:mm').format(record.timeIn!) +
  //     "," +

  final fileName = "FF" + DateTime.now().toString() + ".csv";

  // Encode the string as a List<int> of UTF-8 bytes
  var bytes = utf8.encode(fileContent);

  final stream = Stream.fromIterable(bytes);
  return download(stream, fileName);
}