// code created by https://www.youtube.com/@flutterflowexpert

import 'dart:convert' show utf8;
import 'package:download/download.dart';

Future downloadCollectionAsCSV(List<CarsRecord>? docs) async {
  docs = docs ?? [];

  String fileContent = "name, brand";

  docs.asMap().forEach((index, record) => fileContent = fileContent +
      "\n" +
      record.name.toString() +
      "," +
      record.brand.toString());

  final fileName = "FF" + DateTime.now().toString() + ".csv";

  // Encode the string as a List<int> of UTF-8 bytes
  var bytes = utf8.encode(fileContent);

  final stream = Stream.fromIterable(bytes);
  return download(stream, fileName);
}