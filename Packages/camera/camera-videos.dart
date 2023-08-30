// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=wg4s9hE8N4k
// widgets - Cg9Db2x1bW5fZ2g4ZGtyODMSjQIKD0J1dHRvbl9tMnFwZHkxZxgJImtKZgoSCgZSZWNvcmQ6Bgj/////D0AFGQAAAAAAAABAKQAAAAAAQGBAMQAAAAAAAERASQAAAAAAAPA/UgIQAVoCCAByJAkAAAAAAAAgQBEAAAAAAAAgQBkAAAAAAAAgQCEAAAAAAAAgQPoDAGIAigGHARKAAQoIN2Z2Z2NqaGISdOIBZkJgCg0KC2lzUmVjb3JkaW5nEk8STQgKUkk6RwokChcIDEITIhEKDQoLaXNSZWNvcmRpbmcQARIJCgcSBWZhbHNlEggKBhIEdHJ1ZRoVCg0KC2lzUmVjb3JkaW5nEAUaACAAUAJYAaoCCHpiYm5uc3VsGgIIARKFAQoNVGV4dF91cWk5c3p3dRgCInASEgoLSGVsbG8gV29ybGRABqgBAJoBVgoCAgEqUAgKUkw6Sgo5Ci0IClIpEhkSFwgMQhMiEQoNCgtpc1JlY29yZGluZxABEggKBhIEdHJ1ZSICCAESCAoGEgR0cnVlEgkKBxIFZmFsc2UaAhAD+gMAYgASpgEKEkNvbnRhaW5lcl92bzM3OWN3ORgBIgP6AwBidxI+CgpkaW1lbnNpb25zEjAKFAoKZGltZW5zaW9ucxIGMXJqcjY4MhgiFgoJEQAAAAAAAFlAEgkJAAAAAABAf0ASJwoNcmVjb3JkaW5nVGltZRIWCg8KDXJlY29yZGluZ1RpbWUSAxIBNRoMQ2FtZXJhUmVjb3JkggEMQ2FtZXJhUmVjb3JkmAEBGAQiByICIAH6AwA=
// replace - [{"App State name to start and end video recording": "isRecording"}, {"App State name to the path when video is recording in FB storage": "recordVideoFBStorage"}]
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

import '../../auth/firebase_auth/auth_util.dart';
import '../../backend/firebase_storage/storage.dart';

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
      controller!.startVideoRecording().then((_) {
      }).catchError((error) {
      });
    } else if (!FFAppState().isRecording &&
        controller != null &&
        controller!.value.isRecordingVideo) {
      controller!.stopVideoRecording().then((file) async {
        Uint8List fileAsBytes = await file.readAsBytes();
        setState(() {
          FFAppState().isRecording = false;
        });
        String dir = '/users/' + currentUserUid + '/';
        final downloadUrl = await uploadData(dir + file.path, fileAsBytes);
        FFAppState().recordVideoFBStorage = await downloadUrl ?? '';
      }).catchError((error) {
      });
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