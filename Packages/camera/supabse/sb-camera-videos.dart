// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=0_TIH7xT5_Y
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import '../../auth/supabase_auth/auth_util.dart';
import '../../flutter_flow/upload_data.dart';

import 'package:camera/camera.dart';

class CameraRecord extends StatefulWidget {
  const CameraRecord({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _CameraRecordState createState() => _CameraRecordState();
}

class _CameraRecordState extends State<CameraRecord> {
  CameraController? controller;
  late Future<List<CameraDescription>> _cameras;

  @override
  void initState() {
    super.initState();
    _cameras = availableCameras();
  }

  @override
  void didUpdateWidget(covariant CameraRecord oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (FFAppState().isRecording && !controller!.value.isRecordingVideo) {
      controller!.prepareForVideoRecording();
      controller!.startVideoRecording().then((_) {}).catchError((error) {});
    } else if (!FFAppState().isRecording &&
        controller != null &&
        controller!.value.isRecordingVideo) {
      controller!.stopVideoRecording().then((file) async {
        Uint8List fileAsBytes = await file.readAsBytes();
        setState(() {
          FFAppState().isRecording = false;
        });
        String dir = '/users/' + currentUserUid + '/';
        SelectedFile selectedFile = SelectedFile(
            storagePath: dir + file.path.split('/').last, bytes: fileAsBytes);
        final downloadUrl = await uploadSupabaseStorageFile(
            bucketName: 'YOUR_SUPABASE_BUCKET_NAME',
            selectedFile: selectedFile);
        FFAppState().recordVideoFBStorage = downloadUrl;
      }).catchError((error) {});
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CameraDescription>>(
      future: _cameras,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            if (controller == null) {
              controller =
                  CameraController(snapshot.data![0], ResolutionPreset.max);
              controller!.initialize().then((_) {
                if (!mounted) {
                  return;
                }
                setState(() {});
              });
            }
            return controller!.value.isInitialized
                ? MaterialApp(
                    home: CameraPreview(controller!),
                  )
                : Container();
          } else {
            return Center(child: Text('No cameras available.'));
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
