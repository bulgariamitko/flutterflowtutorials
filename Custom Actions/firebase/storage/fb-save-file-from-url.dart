// YouTube channel - https://www.youtube.com/@flutterflowexpert
// future video - https://www.youtube.com/watch?v=Qv7rhKJ3PxQ
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

import '../../backend/api_requests/api_calls.dart';
import '../../auth/firebase_auth/auth_util.dart';
import '../../backend/firebase_storage/storage.dart';

Future saveFileFromUrl(String? url) async {
  // null safety
  url ??=
      'https://cdn.midjourney.com/8908a048-6e12-4431-9f8a-a70d1f6f4a56/0_2.png';

  // Extract the file extension from the URL
  String fileExtension = p.extension(url);

// Get the current date and time
  final now = DateTime.now();

// Format the date and time as a string
  final formattedDateTime =
      '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}-${now.second.toString().padLeft(2, '0')}';

// Set the file name to the formatted date and time string together with the file extension
  final fileName = '$formattedDateTime$fileExtension';

// Set the directory where you want to store the file (e.g., a folder named 'files' in your storage)
  String directoryPath = '/users/' + currentUserUid + '/files';

// Combine the directory path and file name to create the full storage path
  final storagePath = '$directoryPath/$fileName';

// Download the file from the URL as bytes
  // final response = await http.get(Uri.parse(url));
  final fileAsBytes = await DownloadFileCall.call(
    url: url,
  );
  final Uint8List bytes = fileAsBytes.response!.bodyBytes;

  // Get file size
  int fileSize = bytes.length;

  print(['File size', fileSize]);

  // Check the file size here (example: limit to 10MB)
  if (fileSize > 10 * 1024 * 1024) {
    // File is too large, handle accordingly
    return FFUploadedFile(bytes: bytes, name: 'error');
  }

// Save the file to Firebase storage
  final downloadUrl = await uploadData(storagePath, bytes);

  FFAppState().filePath = downloadUrl ?? '';
}