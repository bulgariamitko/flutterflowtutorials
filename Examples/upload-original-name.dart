// code created by https://www.youtube.com/@flutterflowexpert
// video - no
// support my work - https://github.com/sponsors/bulgariamitko
// community code - https://community.flutterflow.io/database-and-apis/post/filename-ekBGtZkxstn14Ud?highlight=TV5yAHCtfRuUGAW

import 'package:file_picker/file_picker.dart';
import 'dart:convert';

import '../../auth/firebase_auth/auth_util.dart';
import '../../backend/firebase_storage/storage.dart';
import '../../flutter_flow/upload_data.dart';

class GetFilename extends StatefulWidget {
  const GetFilename({Key? key, this.width, this.height}) : super(key: key);

  final double? width;
  final double? height;

  @override
  _GetFilenameState createState() => _GetFilenameState();
}

class _GetFilenameState extends State<GetFilename> {
  String? fileName;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    FFUploadedFile? selectedUploadedFile;
    String? downloadUrl;

    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
      });
      print(result.files.single.name);
      print(result.files.single.bytes);

      // HERE IS WHERE WE UPLOAD
      try {
        selectedUploadedFile = FFUploadedFile(
          name: result.files.single.name,
          bytes: result.files.single.bytes,
        );
        String directoryPath = '/users/' + currentUserUid + '/pdfs/';

        downloadUrl = await uploadData(directoryPath + result.files.single.name,
            result.files.single.bytes!);
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
    } else {
      // User canceled the picker
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No file selected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: _pickFile,
            child: Text('Upload Document'),
          ),
          SizedBox(height: 20),
          if (fileName != null)
            Text(
              'Selected File: $fileName',
              style: TextStyle(fontSize: 16),
            ),
        ],
      ),
    );
  }
}