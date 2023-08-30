// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=JSgDuKIxNg0
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

import 'dart:io';
import 'dart:convert' show utf8;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:download/download.dart';

Future<List<dynamic>> downloadToAnyPlatfromCSV(
  List<CarStruct>? docs,
) async {
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

  final fileName = "FF" + DateTime.now().toString() + ".csv";

  Directory? appDir;

  // Encode the string as a List<int> of UTF-8 bytes
  List<int> bytes = utf8.encode(fileContent);

  Stream<int> stream = Stream.fromIterable(bytes);

  if (kIsWeb) {
    await download(stream, fileName);
    return [
      {'fileName': fileName},
      {'filePath': fileName}
    ];
  } else if (Platform.isAndroid) {
    appDir = await getExternalStorageDirectory();
  } else if (Platform.isIOS) {
    appDir = await getApplicationDocumentsDirectory();
  } else {
    appDir = await getDownloadsDirectory();
  }
  String pathName = appDir?.path ?? "";
  String destinationPath = await getDestinationPathName(fileName, pathName,
      isBackwardSlash: Platform.isWindows);
  await download(stream, destinationPath);

  return [
    {'fileName': fileName},
    {'filePath': destinationPath}
  ];
}

Future<String> getDestinationPathName(String fileName, String pathName,
    {bool isBackwardSlash = true}) async {
  String destinationPath =
      pathName + "${isBackwardSlash ? "\\" : "/"}${fileName}";
  int i = 1;
  bool _isFileExists = await File(destinationPath).exists();
  while (_isFileExists) {
    _isFileExists =
        await File(pathName + "${isBackwardSlash ? "\\" : "/"}($i)${fileName}")
            .exists();
    if (_isFileExists == false) {
      destinationPath =
          pathName + "${isBackwardSlash ? "\\" : "/"}($i)${fileName}";
      break;
    }
    i++;
  }
  return destinationPath;
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the button on the right!