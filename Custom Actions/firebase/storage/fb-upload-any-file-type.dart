// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=H4YBcAb7XxY
// widgets - Cg9Db2x1bW5fOG95emxwMTQS7gEKD0J1dHRvbl92djM1emhrdxgJInxKdwojCgtVcGxvYWQgZmlsZToGCP////8PQAV6ChIINWdhYnJyMTQZAAAAAAAAAEApAAAAAABAYEAxAAAAAAAAREBJAAAAAAAA8D9SAhABWgIIAHIkCQAAAAAAACBAEQAAAAAAACBAGQAAAAAAACBAIQAAAAAAACBA+gMAYgCKAVgSUgoIcXNmMGg3NjMSRtIBOAoaChF1cGxvYWRBbnlGaWxlVHlwZRIFaDhhMnESGhIYCAxCFCISCg4KDGFyZ0ZpbGVUeXBlcxABqgIIeWc4cXg1em4aAggBGAQiGyICEAFyEgkAAAAAAAAAABEAAAAAAAAAAPoDAA==
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

// NOTE! You do not need a custom code for that anymore using FF native actions

import '../../backend/firebase_storage/storage.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../flutter_flow/upload_data.dart';

Future uploadAnyFileType(BuildContext context, List<String>? fileType) async {
  fileType = fileType ?? ['pdf'];
  final selectedFile = await selectFile();
  if (selectedFile != null) {
    FFAppState().update(() {
      FFAppState().isDataUploading = true;
    });
    FFUploadedFile? selectedUploadedFile;
    String? downloadUrl;
    try {
      selectedUploadedFile = FFUploadedFile(
        name: selectedFile.storagePath.split('/').last,
        bytes: Uint8List.fromList(selectedFile.bytes),
      );
      downloadUrl =
          await uploadData(selectedFile.storagePath, selectedFile.bytes);
    } finally {
      FFAppState().update(() {
        FFAppState().isDataUploading = false;
      });
    }
    if (selectedUploadedFile != null && downloadUrl != null) {
      FFAppState().update(() {
        FFAppState().isDataUploading = true;
      });
      // save url to local state
      FFAppState().update(() {
        FFAppState().filePath = downloadUrl!;
      });
    } else {
      return;
    }
  }
}
