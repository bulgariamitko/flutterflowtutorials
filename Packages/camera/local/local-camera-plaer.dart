// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - https://www.youtube.com/watch?v=wg4s9hE8N4k
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

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
  late List<CameraDescription> _cameras;
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;
  bool _isRecording = false;
  File? _videoFile;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void didUpdateWidget(covariant CameraApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (FFAppState().cameraAS.startRecording) {
      if (!_isRecording) {
        _startRecording();
      }
    } else {
      if (_isRecording) {
        _stopRecording();
      }
    }

    if (FFAppState().cameraAS.player == false) {
      setState(() {
        _videoFile = null;
      });
    }
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    final frontCamera = _cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );
    _controller = CameraController(frontCamera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  Future<void> _startRecording() async {
    if (!_controller.value.isInitialized) {
      return;
    }

    try {
      await _controller.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      print("Error starting video recording: $e");
    }
  }

  Future<void> _stopRecording() async {
    if (!_controller.value.isRecordingVideo) {
      return;
    }

    try {
      final videoFile = await _controller.stopVideoRecording();
      final String newPath = videoFile.path.replaceAll('.temp', '.mp4');
      final File tempFile = File(videoFile.path);
      final File newVideoFile = await tempFile.copy(newPath);
      await tempFile.delete();

      setState(() {
        _isRecording = false;
        _videoFile = newVideoFile;
        FFAppState().cameraAS.player = true;
        FFAppState().cameraAS.localPath = newVideoFile.path;
      });

      Uint8List? recordedVideoBytes = await newVideoFile.readAsBytes();
      FFUploadedFile fileToUpload = FFUploadedFile(
        bytes: recordedVideoBytes,
        name: newVideoFile.path,
      );
      widget.saveVideoAction.call(fileToUpload);

      print("Video recorded to: ${newVideoFile.path}");
      // Ensure state is updated to show the video player
      setState(() {});
    } catch (e) {
      print("Error stopping video recording: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _videoFile == null
          ? _initializeControllerFuture == null
                ? Center(child: CircularProgressIndicator())
                : FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CameraPreview(_controller);
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
