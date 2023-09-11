// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=0_TIH7xT5_Y&t=1s
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

import '../../flutter_flow/upload_data.dart';

Future uploadAnyFileType(
  BuildContext context,
  List<String>? fileType,
  String? bucket,
  String? folderPath,
) async {
  // null safety
  fileType ??= ['pdf'];
  bucket ??= 'error';
  folderPath ??= 'error';

  SelectedFile selectedFile = await selectFile(
          storageFolderPath: folderPath, allowedExtensions: fileType) ??
      SelectedFile(bytes: Uint8List(0));
  showUploadMessage(
    context,
    'Uploading file...',
    showLoading: true,
  );

  final String downloadUrl = await uploadSupabaseStorageFile(
      bucketName: bucket, selectedFile: selectedFile);

  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  // save url to local state
  FFAppState().update(() {
    FFAppState().filePath = downloadUrl;
  });

  showUploadMessage(
    context,
    'Success!',
  );
}

