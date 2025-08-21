// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - TBA
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class MyAudioPlayer extends StatefulWidget {
  const MyAudioPlayer({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<MyAudioPlayer> createState() => _MyAudioPlayerState();
}

class _MyAudioPlayerState extends State<MyAudioPlayer>
    with WidgetsBindingObserver {
  final _player = AudioPlayer();
  // bool _shuffleEnabled = false;
  // LoopMode _loopMode = LoopMode.off;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.black),
    );
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(
      const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.mixWithOthers,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        avAudioSessionRouteSharingPolicy:
            AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.media,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ),
    );

    final playlist = FFAppState().playlistDT
        .map((url) => AudioSource.uri(Uri.parse(url.audio)))
        .toList();

    // Find the index of the active song in the playlist
    final activeIndex = FFAppState().playlistDT.indexWhere(
      (track) => track.active,
    );

    // Set the initial index of the player to the active song index
    final initialIndex = activeIndex != -1 ? activeIndex : 0;
    bool firstLoad = true;
    _player.sequenceStateStream.listen((sequenceState) {
      if (!firstLoad) {
        _updatePlaylistActiveState(sequenceState!.currentIndex);
      }

      firstLoad = false;
    });

    try {
      await _player.setAudioSource(
        ConcatenatingAudioSource(children: playlist),
        initialIndex: initialIndex,
      );
    } on PlayerException catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _player.dispose();
    super.dispose();
  }

  void _updatePlaylistActiveState(int currentIndex) {
    FFAppState().update(() {
      for (int i = 0; i < FFAppState().playlistDT.length; i++) {
        FFAppState().playlistDT[i].active = i == currentIndex;
      }
    });
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PopScope(
        onPopInvoked: (context) async {
          // Minimize the app instead of popping the route
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return Future.value(false);
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                          positionData?.bufferedPosition ?? Duration.zero,
                      onChangeEnd: _player.seek,
                    );
                  },
                ),
                ControlButtons(_player),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ControlButtons extends StatefulWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  _ControlButtonsState createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons> {
  bool _shuffleEnabled = false;
  LoopMode _loopMode = LoopMode.off;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            _shuffleEnabled ? Icons.shuffle : Icons.shuffle_outlined,
            color: _shuffleEnabled ? const Color(0xFFf76a43) : null,
          ),
          onPressed: () {
            setState(() {
              _shuffleEnabled = !_shuffleEnabled;
            });
            if (_shuffleEnabled) {
              widget.player.setShuffleModeEnabled(true);
            } else {
              widget.player.setShuffleModeEnabled(false);
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.skip_previous),
          onPressed: () {
            widget.player.seekToPrevious();
          },
        ),
        StreamBuilder<PlayerState>(
          stream: widget.player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: widget.player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: widget.player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => widget.player.seek(Duration.zero),
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: () {
            widget.player.seekToNext();
          },
        ),
        IconButton(
          icon: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                _loopMode == LoopMode.off
                    ? Icons.repeat_outlined
                    : Icons.repeat,
                color: _loopMode == LoopMode.off
                    ? null
                    : const Color(0xFFf76a43),
              ),
              if (_loopMode == LoopMode.one)
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '1',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFf76a43),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          onPressed: () {
            setState(() {
              switch (_loopMode) {
                case LoopMode.off:
                  _loopMode = LoopMode.all;
                  break;
                case LoopMode.all:
                  _loopMode = LoopMode.one;
                  break;
                case LoopMode.one:
                  _loopMode = LoopMode.off;
                  break;
              }
            });
            widget.player.setLoopMode(_loopMode);
          },
        ),
      ],
    );
  }
}

class PositionData {
  const PositionData(this.position, this.bufferedPosition, this.duration);

  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => SizedBox(
          height: 100.0,
          child: Column(
            children: [
              Text(
                '${snapshot.data?.toStringAsFixed(1)}',
                style: const TextStyle(
                  fontFamily: 'Fixed',
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class SeekBar extends StatefulWidget {
  const SeekBar({
    Key? key,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  }) : super(key: key);

  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  @override
  SeekBarState createState() => SeekBarState();
}

class SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sliderThemeData = SliderTheme.of(context).copyWith(trackHeight: 2.0);
  }

  @override
  Widget build(BuildContext context) {
    final duration = widget.duration.inMilliseconds.toDouble();
    final position = widget.position.inMilliseconds.toDouble();
    final bufferedPosition = widget.bufferedPosition.inMilliseconds.toDouble();

    return Stack(
      children: [
        SliderTheme(
          data: _sliderThemeData.copyWith(
            thumbColor: Colors.white,
            overlayColor: Colors.white,
            activeTrackColor: Color(0xFFf76a43),
            inactiveTrackColor: Color.fromARGB(255, 246, 57, 5),
          ),
          child: ExcludeSemantics(
            child: Slider(
              min: 0.0,
              max: duration > 0 ? duration : 1.0,
              value: bufferedPosition.clamp(0.0, duration),
              onChanged: (value) {
                setState(() {
                  _dragValue = value;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(Duration(milliseconds: value.round()));
                }
              },
              onChangeEnd: (value) {
                if (widget.onChangeEnd != null) {
                  widget.onChangeEnd!(Duration(milliseconds: value.round()));
                }
                _dragValue = null;
              },
            ),
          ),
        ),
        SliderTheme(
          data: _sliderThemeData.copyWith(
            thumbColor: Color(0xFFf76a43),
            activeTrackColor: Color(0xFFf76a43),
            // inactiveTrackColor: Color.fromARGB(255, 246, 57, 5),
          ),
          child: Slider(
            min: 0.0,
            max: duration > 0 ? duration : 1.0,
            value: min(_dragValue ?? position, duration),
            onChanged: (value) {
              setState(() {
                _dragValue = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(Duration(milliseconds: value.round()));
              }
            },
            onChangeEnd: (value) {
              if (widget.onChangeEnd != null) {
                widget.onChangeEnd!(Duration(milliseconds: value.round()));
              }
              _dragValue = null;
            },
          ),
        ),
        Positioned(
          right: 16.0,
          bottom: 0.0,
          child: Text(
            RegExp(
                  r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$',
                ).firstMatch("$_remaining")?.group(1) ??
                '$_remaining',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}
