// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=H4YBcAb7XxY
// widgets - Cg9Db2x1bW5fOG95emxwMTQS7gEKD0J1dHRvbl92djM1emhrdxgJInxKdwojCgtVcGxvYWQgZmlsZToGCP////8PQAV6ChIINWdhYnJyMTQZAAAAAAAAAEApAAAAAABAYEAxAAAAAAAAREBJAAAAAAAA8D9SAhABWgIIAHIkCQAAAAAAACBAEQAAAAAAACBAGQAAAAAAACBAIQAAAAAAACBA+gMAYgCKAVgSUgoIcXNmMGg3NjMSRtIBOAoaChF1cGxvYWRBbnlGaWxlVHlwZRIFaDhhMnESGhIYCAxCFCISCg4KDGFyZ0ZpbGVUeXBlcxABqgIIeWc4cXg1em4aAggBGAQiGyICEAFyEgkAAAAAAAAAABEAAAAAAAAAAPoDAA==
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

import '../../backend/firebase_storage/storage.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../flutter_flow/upload_media.dart';

Future uploadAnyFileType(BuildContext context, List<String>? fileType) async {
  fileType = fileType ?? ['pdf'];

  final selectedFile = await selectFile(allowedExtensions: fileType);
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
