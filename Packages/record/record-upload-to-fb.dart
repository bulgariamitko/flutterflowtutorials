// code created by https://www.youtube.com/@flutterflowexpert
// future video - https://www.youtube.com/watch?v=rrgw84My5tw
// widgets - Cg9Db2x1bW5fams0eDgwdjISiQEKEkNvbnRhaW5lcl9hNHB3MHlveBgBIgP6AwBiVBI+CgpkaW1lbnNpb25zEjAKFAoKZGltZW5zaW9ucxIGZ2Nka2U4MhgiFgoJEQAAAAAAAFlAEgkJAAAAAADAYkAaElNvdW5kUmVjb3JkQW5kUGxheYIBElNvdW5kUmVjb3JkQW5kUGxheZgBARJJCg1UZXh0X24zenUxbXd2GAIiNBISCgtIZWxsbyBXb3JsZEAGqAEAmgEaCgICASoUCAxCECIOCgoKCGZpbGVQYXRoEAH6AwBiABI9Cg1UZXh0X2FyaTNjYTRoGAIiKBISCgtIZWxsbyBXb3JsZEAGqAEAmgEOCgICASoICAJCBAoCCAL6AwBiABgEIgUiAPoDAA==
// replace - [{"App State name": "filePath"}, {"File audio extention": "opus"}]
// support my work - https://github.com/sponsors/bulgariamitko

import '../../auth/firebase_auth/auth_util.dart';
import '../../backend/firebase_storage/storage.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:typed_data';
import 'package:record/record.dart';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundRecordAndPlay extends StatefulWidget {
  const SoundRecordAndPlay({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _SoundRecordAndPlayState createState() => _SoundRecordAndPlayState();
}

class _SoundRecordAndPlayState extends State<SoundRecordAndPlay> {
  bool _isRecording = false;
  bool _isPaused = false;
  bool _isPlaying = false;
  int _recordDuration = 0;
  String? path = '';
  Timer? _timer;
  Timer? _ampTimer;
  final _audioRecorder = Record();
  final player = AudioPlayer();

  Amplitude? _amplitude;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  void dispose() {
    _timer?.cancel();
    _ampTimer?.cancel();
    _audioRecorder.dispose();
    player.stop();
    super.dispose();
  }

  Future<Uint8List?> getUint8ListFromBlobUrl(String? blobUrl) async {
    if (blobUrl == null) {
      return null;
    }

    try {
      final response = await http.get(Uri.parse(blobUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to download the file');
      }
    } catch (e) {
      print('Error downloading file: $e');
      return null;
    }
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start();

        bool isRecording = await _audioRecorder.isRecording();
        setState(() {
          _isRecording = isRecording;
          _recordDuration = 0;
        });

        _startTimer();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _ampTimer?.cancel();

    // This is the path of the recorded file.
    path = await _audioRecorder.stop();

    setState(() => _isRecording = false);
    setState(() => _isPaused = true);

    FFAppState().filePath = path ?? '';
    Uint8List? bytes = await getUint8ListFromBlobUrl(path);

    if (bytes != null) {
      // Get the current date and time
      final now = DateTime.now();

      // Format the date and time as a string
      final formattedDateTime =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}-${now.second.toString().padLeft(2, '0')}';

      // Set the file name to the formatted date and time string together with the file extension
      final fileName = '$formattedDateTime.opus';

      // Set the directory where you want to store the file (e.g., a folder named 'files' in your storage)
      String directoryPath = '/users/' + currentUserUid + '/audio-recordings';

      // Combine the directory path and file name to create the full storage path
      final storagePath = '$directoryPath/$fileName';

      // Save the file to Firebase storage
      final downloadUrl = await uploadData(storagePath, bytes);

      FFAppState().filePath = downloadUrl ?? '';
    } else {
      print('Failed to read the recorded audio file');
    }

    // FFAppState().filePath = path ?? '';
  }

  Future<void> _play() async {
    await player.setReleaseMode(ReleaseMode.loop);
    kIsWeb
        ? await player.play(UrlSource(path!))
        : await player.play(DeviceFileSource(path!));

    setState(() => _isPaused = false);
    setState(() => _isPlaying = true);
  }

  Future<void> _pause() async {
    await player.pause();

    setState(() => _isPaused = true);
    setState(() => _isPlaying = false);
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: FlutterFlowTheme.of(context).displayMedium,
    );
  }

  Widget _buildText() {
    if (_isRecording) {
      return _buildTimer();
    } else if (_isPaused) {
      return Text(
        'Tap to listen',
        style: FlutterFlowTheme.of(context).displayMedium,
      );
    } else if (_isPlaying) {
      return Text(
        'Tap to pause',
        style: FlutterFlowTheme.of(context).displayMedium,
      );
    } else {
      return Text(
        'Tap to record',
        style: FlutterFlowTheme.of(context).displayMedium,
      );
    }
  }

  Widget _buildSubHeader() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildText(),
        ],
      ),
    );
  }

  Widget _buildRecorder() {
    if (_isRecording) {
      return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
        child: InkWell(
          onTap: () async {
            _stop();
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Color(0x4DD9376E),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.stop_rounded,
              color: FlutterFlowTheme.of(context).primary,
              size: 45,
            ),
          ),
        ),
      );
    } else if (_isPaused) {
      return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
        child: InkWell(
          onTap: () async {
            _play();
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).alternate,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.play_arrow_rounded,
              color: FlutterFlowTheme.of(context).secondaryBackground,
              size: 45,
            ),
          ),
        ),
      );
    } else if (_isPlaying) {
      return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
        child: InkWell(
          onTap: () async {
            _pause();
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.pause_rounded,
              color: FlutterFlowTheme.of(context).alternate,
              size: 45,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
        child: InkWell(
          onTap: () async {
            _start();
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Color(0x4DD9376E),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mic_none,
              color: FlutterFlowTheme.of(context).primary,
              size: 45,
            ),
          ),
        ),
      );
    }
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }

  void _startTimer() {
    _timer?.cancel();
    _ampTimer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });

    _ampTimer =
        Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
      _amplitude = await _audioRecorder.getAmplitude();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRecorder(),
              _buildSubHeader(),
            ],
          ),
        ],
      ),
    );
  }
}