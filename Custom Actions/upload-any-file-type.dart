// code created by https://www.youtube.com/@flutterflowexpert

import '../../backend/firebase_storage/storage.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../flutter_flow/upload_media.dart';

Future uploadAnyFileType(BuildContext context, String? fileType) async {
  fileType = fileType ?? 'pdf';

  final String uploadedFileUrl = '';

  final selectedFile = await selectFile(allowedExtensions: [fileType]);
  if (selectedFile != null) {
    showUploadMessage(
      context,
      'Uploading file...',
      showLoading: true,
    );
    final downloadUrl =
        await uploadData(selectedFile.storagePath, selectedFile.bytes);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (downloadUrl != null) {
      // save url to local state
      FFAppState().update(() {
        FFAppState().filePath = downloadUrl;
      });

      showUploadMessage(
        context,
        'Success!',
      );
    } else {
      showUploadMessage(
        context,
        'Failed to upload file',
      );
      return;
    }
  }
}