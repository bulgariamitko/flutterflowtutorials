// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://youtube.com/watch?v=rAw5riRVHuc
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

import 'dart:convert';
import '../../flutter_flow/upload_data.dart';

Future uploadRawFileToSB(
    String? bytes, String? bucket, String? fullFilePath) async {
  // null safety
  bytes ??= '';
  bucket ??= 'error';
  fullFilePath ??= 'error';

  SelectedFile selectedFile = SelectedFile(
      storagePath: fullFilePath, bytes: Uint8List.fromList(utf8.encode(bytes)));

  final String downloadUrl = await uploadSupabaseStorageFile(
      bucketName: bucket, selectedFile: selectedFile);

  FFAppState().update(() {
    FFAppState().filePath = downloadUrl;
  });
}
