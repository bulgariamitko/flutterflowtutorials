// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=LfAwHZndeWQ
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'package:video_player/video_player.dart';
import 'dart:io';

class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({
    super.key,
    this.width,
    this.height,
    required this.videoPathOrUrl,
  });

  final double? width;
  final double? height;
  final String videoPathOrUrl;

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  bool _isPlaying = false;
  bool _isLocalFile = false;

  @override
  void initState() {
    super.initState();
    _isLocalFile = !(widget.videoPathOrUrl.startsWith('http') ||
        widget.videoPathOrUrl.startsWith('https'));
    if (!_isLocalFile) {
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoPathOrUrl))
            ..initialize().then((_) {
              setState(() {});
            });
    } else {
      _videoPlayerController =
          VideoPlayerController.file(File(widget.videoPathOrUrl))
            ..initialize().then((_) {
              setState(() {});
            });
    }
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
    return Scaffold(
      body: _videoPlayerController.value.isInitialized
          ? Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: _isLocalFile && Platform.isAndroid
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
          : Center(child: CircularProgressIndicator()),
    );
  }
}
