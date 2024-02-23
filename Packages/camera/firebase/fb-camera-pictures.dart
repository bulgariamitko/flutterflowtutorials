// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=wg4s9hE8N4k
// widgets - Cg9Db2x1bW5fMGU0aGRrZ3ISpAQKD0J1dHRvbl94dm40aWJodRgJImpKZQoRCgVTbWlsZToGCP////8PQAUZAAAAAAAAAEApAAAAAABAYEAxAAAAAAAAREBJAAAAAAAA8D9SAhABWgIIAHIkCQAAAAAAACBAEQAAAAAAACBAGQAAAAAAACBAIQAAAAAAACBA+gMAYgCKAZ8DEpgDCghreDZ3aDV2ZxIr4gEdQhcKCwoJbWFrZVBob3RvEggKBhIEdHJ1ZVACWAGqAgh2MHNqbXdqeireAgoIcGE0Zm1zaTYSEfoBAwiIJ6oCCGg3dnVqM2RhKr4CCgg3MWx6OHZmbhKxAiKjAgqgAgoICgZwaG90b3MSkwIKGgoEZGF0ZRISCgYKBGRhdGUyCAgBQgQaAggBCkAKBG5hbWUSOAoGCgRuYW1lMi4IClIqCgASBwoFEgNwaWMSExIRCAxCDSILCgcKBWluZGV4EAESCAoGEgQuanBnCiAKB3VzZXJSZWYSFQoJCgd1c2VyUmVmMggIAkIECgIICAoeCgZ1c2VyaWQSFAoICgZ1c2VyaWQyCAgCQgQKAggCCioKCmZvbGRlck5hbWUSHAoMCgpmb2xkZXJOYW1lEgwSCk5ldyBmb2xkZXIKRQoEcGF0aBI9CgYKBHBhdGgyMwgKUi8SFhIUCAxCECIOCgoKCGZpbGVQYXRoEAEaFQoMc3RyVG9JbWdQYXRoEgVvN2Vxa6oCCHIzdTg4anFjGgIIARKFAQoNVGV4dF96bDloMGdmcRgCInASEgoLSGVsbG8gV29ybGRABqgBAJoBVgoCAgEqUAgKUkw6Sgo5Ci0IClIpEhkSFwgMQhMiEQoNCgtpc1JlY29yZGluZxABEggKBhIEdHJ1ZSICCAESCAoGEgR0cnVlEgkKBxIFZmFsc2UaAhAD+gMAYgASewoSQ29udGFpbmVyX2p5Y2d5bnFkGAEiA/oDAGJNEj4KCmRpbWVuc2lvbnMSMAoUCgpkaW1lbnNpb25zEgYxcmpyNjgyGCIWCgkRAAAAAAAAWUASCQkAAAAAAEB/QBoLQ2FtZXJhUGhvdG+CAQtDYW1lcmFQaG90b5gBARKqAgoPQ29sdW1uXzIxcWRjbGhoEiwKDVRleHRfYm51OTE3a3kYAiIXEhIKC0ZvbGRlciBuYW1lQAaoAQD6AwBiABLfAQoMUm93X2Y5a3JqZjFwEoUBCg5JbWFnZV81YWR5YXI4cBgHIm8yQAoiaHR0cHM6Ly9waWNzdW0ucGhvdG9zL3NlZWQvMzMyLzYwMBABGAMiFgoJCQAAAAAAAFlAEgkJAAAAAAAAWUCaAScKAgYBKiEIBBIMUm93X2Y5a3JqZjFwQgISAEoLggEICgYKBHBhdGj6AwBiABgDIgoaAPoDAPIEAgoAUjkKDhAHGggKBnBob3RvcyABEiUKCAoGcGhvdG9zEhcKCQoHdXNlclJlZhABSggIAkIECgIICCgAOgAYBCIFIgD6AwAYBCIHIgIgAfoDAA==
// replace - [{"App State name to take picture": "makePhoto"}, {"App State name to index the picture": "index"}, {"App State name to the file path in FB storage": "filePath"}]
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import '../../auth/firebase_auth/auth_util.dart';
import '../../backend/firebase_storage/storage.dart';
import 'package:camera/camera.dart';

class CameraPhoto extends StatefulWidget {
  const CameraPhoto({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _CameraPhotoState createState() => _CameraPhotoState();
}

class _CameraPhotoState extends State<CameraPhoto> {
  CameraController? controller;
  late Future<List<CameraDescription>> _cameras;

  @override
  void initState() {
    super.initState();
    _cameras = availableCameras();
  }

  @override
  void didUpdateWidget(covariant CameraPhoto oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (FFAppState().makePhoto) {
      controller!.takePicture().then((file) async {
        Uint8List fileAsBytes = await file.readAsBytes();
        FFAppState().update(() {
          FFAppState().makePhoto = false;
        });
        String dir = '/users/' + currentUserUid + '/';
        final downloadUrl = await uploadData(
            dir + FFAppState().index.toString() + '.jpg', fileAsBytes);
        FFAppState().update(() {
          FFAppState().index = FFAppState().index + 1;
          FFAppState().filePath = downloadUrl ?? '';
        });
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
