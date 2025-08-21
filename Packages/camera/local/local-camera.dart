// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - https://www.youtube.com/watch?v=wg4s9hE8N4k
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:download/download.dart';

class CameraVideoLocally extends StatefulWidget {
  const CameraVideoLocally({Key? key, this.width, this.height})
    : super(key: key);

  final double? width;
  final double? height;

  @override
  _CameraVideoLocallyState createState() => _CameraVideoLocallyState();
}

class _CameraVideoLocallyState extends State<CameraVideoLocally> {
  CameraController? controller;
  late Future<List<CameraDescription>> _cameras;

  @override
  void initState() {
    super.initState();
    _cameras = availableCameras();
  }

  @override
  void didUpdateWidget(covariant CameraVideoLocally oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (FFAppState().startVideo) {
      // Start video recording
      controller
          ?.startVideoRecording()
          .then((_) {
            FFAppState().update(() {
              print('Video recording started');
            });
          })
          .catchError((error) {
            print('Error starting video recording: $error');
          });
    } else {
      // Stop video recording and save the file locally
      controller
          ?.stopVideoRecording()
          .then((file) async {
            print('Video recording stopped');

            Directory? appDir;
            Stream<int> stream = Stream.fromFuture(
              file.readAsBytes(),
            ).expand((bytes) => bytes);

            final dateFolderName = DateFormat(
              'yyyy-MM-dd',
            ).format(DateTime.now());
            final videoPrefix = "FF";
            String videoNumber = "01";

            if (kIsWeb) {
              // Web platform doesn't support directories in the same way, handle differently
              final fileName = "$videoPrefix$dateFolderName-$videoNumber.mp4";
              await download(stream, fileName);
            } else {
              if (Platform.isAndroid) {
                appDir = await getExternalStorageDirectory();
              } else if (Platform.isIOS) {
                appDir = await getApplicationDocumentsDirectory();
              } else {
                appDir = await getDownloadsDirectory();
              }

              String pathName = appDir?.path ?? "";
              String dateFolderPath = "$pathName/$dateFolderName";
              await Directory(
                dateFolderPath,
              ).create(recursive: true); // Ensure the directory exists

              // Check existing files to determine next video number
              List<FileSystemEntity> existingFiles = Directory(
                dateFolderPath,
              ).listSync();
              int videoCount = existingFiles
                  .where((file) => file.path.endsWith('.mp4'))
                  .length;
              videoNumber = (videoCount + 1).toString().padLeft(
                2,
                '0',
              ); // Ensures format 01, 02, ...

              String finalFileName = "$videoPrefix$videoNumber.mp4";
              String destinationPath = "$dateFolderPath/$finalFileName";

              await download(stream, destinationPath);

              FFAppState().update(() {
                FFAppState().lastFileName = finalFileName;
                FFAppState().lastFilePath = destinationPath;
              });
            }
          })
          .catchError((error) {
            print('Error stopping video recording: $error');
          });
    }
  }

  Future<String> getDestinationPathName(
    String fileName,
    String pathName, {
    bool isBackwardSlash = true,
  }) async {
    String destinationPath =
        pathName + "${isBackwardSlash ? "\\" : "/"}${fileName}";
    int i = 1;
    bool _isFileExists = await File(destinationPath).exists();
    while (_isFileExists) {
      _isFileExists = await File(
        pathName + "${isBackwardSlash ? "\\" : "/"}($i)${fileName}",
      ).exists();
      if (_isFileExists == false) {
        destinationPath =
            pathName + "${isBackwardSlash ? "\\" : "/"}($i)${fileName}";
        break;
      }
      i++;
    }
    return destinationPath;
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
              controller = CameraController(
                snapshot.data![0],
                ResolutionPreset.max,
              );
              controller!.initialize().then((_) {
                if (!mounted) {
                  return;
                }
                setState(() {});
              });
            }
            return controller!.value.isInitialized
                ? MaterialApp(home: CameraPreview(controller!))
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
