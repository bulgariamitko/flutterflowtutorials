// code created by https://www.youtube.com/@flutterflowexpert
// video - https://youtube.com/watch?v=rAw5riRVHuc
// support my work - https://github.com/sponsors/bulgariamitko

import 'dart:convert';

import '../../auth/firebase_auth/auth_util.dart';
import '../../backend/firebase_storage/storage.dart';

Future uploadRawFileToFB(String bytes) async {
  FFUploadedFile? selectedUploadedFile;
  String? downloadUrl;

  try {
    selectedUploadedFile = FFUploadedFile(
      name: 'name',
      bytes: Uint8List.fromList(utf8.encode(bytes)),
    );
    String directoryPath = '/users/' + currentUserUid + '/pdfs';

    downloadUrl = await uploadData(
        directoryPath + '/demo.pdf', Uint8List.fromList(utf8.encode(bytes)));
  } finally {
    FFAppState().update(() {
      FFAppState().isDataUploading = false;
    });
  }
  if (downloadUrl != null) {
    FFAppState().update(() {
      FFAppState().isDataUploading = true;
    });
    // save url to local state
    FFAppState().update(() {
      FFAppState().filePath = downloadUrl!;
    });
  }
}