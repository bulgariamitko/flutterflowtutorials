// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - https://www.youtube.com/watch?v=wg4s9hE8N4k
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'package:cross_file/cross_file.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:path/path.dart' as p;

class CameraApp extends StatefulWidget {
  const CameraApp({
    super.key,
    this.width,
    this.height,
    required this.saveVideoAction,
  });

  final double? width;
  final double? height;
  final Future Function(FFUploadedFile videoData) saveVideoAction;

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  List<CameraDescription>? _cameras;
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isRecording = false;
  File? _videoFile;
  bool? _currentCameraIsFront;
  bool _isSwitchingCamera = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void didUpdateWidget(covariant CameraApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    _handleRecordingState();
    _handlePlayerState();
    _handleCameraSwitch();
  }

  void _handleRecordingState() {
    if (FFAppState().cameraAS.startRecording && !_isRecording) {
      _startRecording();
    } else if (!FFAppState().cameraAS.startRecording && _isRecording) {
      _stopRecording();
    }
  }

  void _handlePlayerState() {
    if (FFAppState().cameraAS.player == false) {
      setState(() {
        _videoFile = null;
      });
    }
  }

  void _handleCameraSwitch() {
    final shouldBeFrontCamera = FFAppState().cameraAS.frontCamera;
    if (_currentCameraIsFront != shouldBeFrontCamera && !_isSwitchingCamera) {
      _switchCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        await _switchCamera();
      }
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.isEmpty) return;

    setState(() {
      _isSwitchingCamera = true;
    });

    final shouldBeFrontCamera = FFAppState().cameraAS.frontCamera;
    final newCamera = _getCamera(shouldBeFrontCamera);

    await _controller?.dispose();

    _controller = CameraController(
      newCamera,
      ResolutionPreset.high,
      enableAudio: true,
    );

    try {
      _initializeControllerFuture = _controller!.initialize();
      await _initializeControllerFuture;
    } catch (e) {
      print("Error switching camera: $e");
    }

    _currentCameraIsFront = shouldBeFrontCamera;

    if (mounted) {
      setState(() {
        _isSwitchingCamera = false;
      });
    }
  }

  CameraDescription _getCamera(bool wantFrontCamera) {
    return _cameras!.firstWhere(
      (camera) =>
          camera.lensDirection ==
          (wantFrontCamera
              ? CameraLensDirection.front
              : CameraLensDirection.back),
      orElse: () => _cameras!.first,
    );
  }

  Future<void> _startRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await _controller?.prepareForVideoRecording();
      }
      await _controller?.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      print("Error starting video recording: $e");
    }
  }

  Future<void> _stopRecording() async {
    if (_controller == null || !_controller!.value.isRecordingVideo) {
      return;
    }

    try {
      final XFile? videoFile = await _controller?.stopVideoRecording();
      if (videoFile == null) {
        print("Error: Video file is null after stopping recording");
        return;
      }

      final String videoPath = videoFile.path;
      final Directory directory = await getApplicationSupportDirectory();
      final String newPath = p.join(
        directory.path,
        '${p.basenameWithoutExtension(videoPath)}.mp4',
      );
      // Create a new file with .mp4 extension
      //final Directory directory = await getApplicationDocumentsDirectory();
      // final directory = await getTemporaryDirectory();
      // final Directory directory = await getApplicationSupportDirectory();
      // final Directory directory = await getLibraryDirectory();

      // final File newVideoFile = await File(videoFile.path).rename(newPath);
      // Use copy instead of rename to ensure the operation works across different filesystems
      // Create a new File from the XFile
      final File originalFile = File(videoFile.path);
      final File newVideoFile = await originalFile.copy(newPath);

      // Delete the original file after successful copy
      await originalFile.delete();

      setState(() {
        _isRecording = false;
        _videoFile = newVideoFile;
        FFAppState().cameraAS.player = true;
        FFAppState().cameraAS.localPath = newVideoFile.path;
      });

      // Read file as stream to handle large files more efficiently
      final fileStream = newVideoFile.openRead();
      final fileToUpload = FFUploadedFile(
        bytes: await fileStream.toList().then(
          (chunks) => Uint8List.fromList(chunks.expand((x) => x).toList()),
        ),
        name: p.basename(newVideoFile.path),
      );

      await widget.saveVideoAction.call(fileToUpload);
      print("Video recorded to: ${newVideoFile.path}");
      setState(() {});
    } catch (e) {
      print("Error stopping video recording: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _videoFile == null
          ? _cameras == null || _controller == null || _isSwitchingCamera
                ? Center(child: CircularProgressIndicator())
                : FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CameraPreview(_controller!);
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  )
          : VideoPlayerWidget(videoFile: _videoFile!),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final File videoFile;

  VideoPlayerWidget({required this.videoFile});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
      });
    _videoPlayerController.addListener(_videoListener);
  }

  void _videoListener() {
    if (_videoPlayerController.value.position ==
        _videoPlayerController.value.duration) {
      setState(() {
        _isPlaying = false;
        _videoPlayerController.seekTo(Duration.zero);
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.removeListener(_videoListener);
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _playPauseVideo() {
    setState(() {
      if (_videoPlayerController.value.isPlaying) {
        _videoPlayerController.pause();
      } else {
        if (_videoPlayerController.value.position ==
            _videoPlayerController.value.duration) {
          _videoPlayerController.seekTo(Duration.zero);
        }
        _videoPlayerController.play();
      }
      _isPlaying = _videoPlayerController.value.isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _videoPlayerController.value.isInitialized
        ? Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: Platform.isAndroid
                      ? RotatedBox(
                          quarterTurns: -1,
                          child: VideoPlayer(_videoPlayerController),
                        )
                      : VideoPlayer(_videoPlayerController),
                ),
              ),
              IconButton(
                iconSize: 150.0,
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: _playPauseVideo,
              ),
              Positioned(
                bottom: 10.0,
                left: 0,
                right: 0,
                child: VideoProgressIndicator(
                  _videoPlayerController,
                  allowScrubbing: true,
                ),
              ),
            ],
          )
        : Center(child: CircularProgressIndicator());
  }
}
