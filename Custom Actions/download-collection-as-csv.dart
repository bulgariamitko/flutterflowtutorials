// code created by https://www.youtube.com/@flutterflowexpert

import 'package:download/download.dart';
import 'dart:convert';

Future downloadCollectionAsCSV(List<WordsRecord>? query) async {
  query = query ?? [];

  String fileContent = "name, phone, word, datetime";

  query.asMap().forEach((index, record) => fileContent = fileContent +
      "\n" +
      record.name.toString() +
      "," +
      record.phone.toString() +
      "," +
      record.word.toString() +
      "," +
      record.datetime.toString());

  final fileName = "Yettel" + DateTime.now().toString() + ".csv";

  // Encode the string as a List<int> of UTF-8 bytes
  var bytes = utf8.encode(fileContent);

  final stream = Stream.fromIterable(bytes);
  return download(stream, fileName);
}