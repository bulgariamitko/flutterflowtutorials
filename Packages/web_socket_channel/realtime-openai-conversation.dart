// YouTube channel - https://www.youtube.com/@dimitarklaturov
// paid video -
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';

class RealtimeOpenAIAudioCon extends StatefulWidget {
  const RealtimeOpenAIAudioCon({
    super.key,
    this.width,
    this.height,
    required this.apiKey,
  });

  final double? width;
  final double? height;
  final String apiKey;

  @override
  State<RealtimeOpenAIAudioCon> createState() => _RealtimeOpenAIAudioConState();
}

class _RealtimeOpenAIAudioConState extends State<RealtimeOpenAIAudioCon> {
  WebSocketChannel? _channel;
  Record? _audioRecorder;
  AudioPlayer? _audioPlayer;
  bool _isRecording = false;
  bool _isConnected = false;
  String _lastTranscript = '';
  String _assistantResponse = '';
  String _errorMessage = '';
  String? _tempFilePath;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int maxReconnectAttempts = 3;
  List<Uint8List> _audioBuffer = [];

  @override
  void initState() {
    super.initState();
    print('Initializing RealtimeOpenAIAudioCon...');
    _audioRecorder = Record();
    _audioPlayer = AudioPlayer();
    _initializeOpenAI();
  }

  Future<void> _initializeOpenAI() async {
    print('Attempting to initialize OpenAI connection...');
    if (_reconnectAttempts >= maxReconnectAttempts) {
      print('Max reconnection attempts reached');
      setState(() {
        _errorMessage =
            'Maximum reconnection attempts reached. Please try again later.';
        _isConnected = false;
      });
      return;
    }

    try {
      // Correct WebSocket URL for the realtime API
      final wsUrl = Uri.parse(
        'wss://api.openai.com/v1/realtime?model=gpt-4o-realtime-preview-2024-10-01',
      );

      print('Connecting to WebSocket URL: $wsUrl');

      _channel = IOWebSocketChannel.connect(
        wsUrl,
        headers: {
          'Authorization': 'Bearer ${widget.apiKey}',
          'Content-Type': 'application/json',
          'OpenAI-Beta': 'realtime=v1',
        },
        pingInterval: const Duration(seconds: 30),
      );

      print('WebSocket connection established');

      bool connected = false;
      Timer(const Duration(seconds: 5), () {
        if (!connected && mounted) {
          print('Connection timeout occurred');
          _handleConnectionError('Connection timeout');
        }
      });

      _channel?.stream.listen(
        (message) {
          print('Received WebSocket message: $message');
          connected = true;
          _handleServerMessage(jsonDecode(message));
        },
        onError: (error) {
          print('WebSocket error occurred: $error');
          _handleConnectionError('WebSocket error: ${error.toString()}');
        },
        onDone: () {
          print('WebSocket connection closed');
          if (mounted) {
            setState(() {
              _isConnected = false;
              _errorMessage = 'Connection closed';
            });
            _attemptReconnect();
          }
        },
        cancelOnError: true,
      );

      await _sendSessionConfig();
      print('Session config sent successfully');

      if (mounted) {
        setState(() {
          _isConnected = true;
          _errorMessage = '';
        });
      }
    } catch (e) {
      print('Error during initialization: $e');
      _handleConnectionError('Connection failed: ${e.toString()}');
    }
  }

  Future<void> _sendSessionConfig() async {
    print('Sending session configuration...');
    if (_channel == null) {
      print('Channel is null, cannot send session config');
      return;
    }

    try {
      final sessionConfig = {
        "event_id": "ev_session_${DateTime.now().millisecondsSinceEpoch}",
        "type": "session.update",
        "session": {
          "modalities": ["text", "audio"],
          "instructions": "You are a helpful assistant.",
          "voice": "alloy",
          "input_audio_format": "pcm16",
          "output_audio_format": "pcm16",
          "input_audio_transcription": {"model": "whisper-1"},
          "turn_detection": {
            "type": "server_vad",
            "threshold": 0.5,
            "prefix_padding_ms": 300,
            "silence_duration_ms": 500,
          },
        },
      };

      print('Session config object created: ${jsonEncode(sessionConfig)}');
      _channel?.sink.add(jsonEncode(sessionConfig));
      print('Session config sent successfully');
    } catch (e) {
      print('Error sending session config: $e');
      _handleConnectionError('Failed to send session config: ${e.toString()}');
    }
  }

  Future<void> _startRecording() async {
    print('Starting recording...');
    if (!_isConnected) {
      print('Not connected, cannot start recording');
      return;
    }

    try {
      if (await _audioRecorder?.hasPermission() ?? false) {
        final tempDir = await getTemporaryDirectory();
        _tempFilePath =
            '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.raw';
        print('Recording to temp file: $_tempFilePath');

        await _audioRecorder?.start(
          path: _tempFilePath,
          encoder: AudioEncoder.pcm16bit,
          samplingRate: 24000,
          numChannels: 1,
        );

        print('Recording started successfully');
        setState(() => _isRecording = true);
      } else {
        print('Microphone permission denied');
        setState(() => _errorMessage = 'Microphone permission denied');
      }
    } catch (e) {
      print('Error starting recording: $e');
      setState(() {
        _errorMessage = e.toString();
        _isRecording = false;
      });
    }
  }

  Future<void> _stopRecording() async {
    print('Stopping recording...');
    try {
      if (_isRecording) {
        final path = await _audioRecorder?.stop();
        print('Recording stopped, path: $path');
        setState(() => _isRecording = false);

        if (path != null) {
          final file = File(path);
          final audioBytes = await file.readAsBytes();
          print('Audio bytes read: ${audioBytes.length}');
          await _sendAudioData(audioBytes);
          await file.delete();
          print('Temporary file deleted');
        }
      }
    } catch (e) {
      print('Error stopping recording: $e');
      setState(() => _errorMessage = e.toString());
    }
  }

  Future<void> _sendAudioData(Uint8List audioData) async {
    print('Sending audio data, size: ${audioData.length} bytes');
    try {
      // First message: Audio data
      final audioMessage = {
        "event_id": "ev_audio_${DateTime.now().millisecondsSinceEpoch}",
        "type": "input_audio_buffer.append",
        "audio": base64Encode(audioData),
      };

      print('Sending audio message');
      _channel?.sink.add(jsonEncode(audioMessage));

      // Second message: Commit the audio
      final commitMessage = {
        "event_id": "ev_commit_${DateTime.now().millisecondsSinceEpoch}",
        "type": "input_audio_buffer.commit",
      };

      print('Sending commit message');
      _channel?.sink.add(jsonEncode(commitMessage));

      // Wait a bit for the audio to be processed
      await Future.delayed(const Duration(milliseconds: 500));

      // Third message: Create response with minimum required fields
      final responseMessage = {
        "event_id": "ev_response_${DateTime.now().millisecondsSinceEpoch}",
        "type": "response.create",
      };

      print('Sending response create message');
      _channel?.sink.add(jsonEncode(responseMessage));

      print('Audio data and response request sent successfully');
    } catch (e) {
      print('Error sending audio data: $e');
      setState(() => _errorMessage = e.toString());
    }
  }

  void _handleServerMessage(Map<String, dynamic> data) async {
    print('Handling server message of type: ${data['type']}');

    switch (data['type']) {
      case 'conversation.item.input_audio_transcription.completed':
        print('Received transcription: ${data['transcript']}');
        setState(() => _lastTranscript = data['transcript']);
        break;

      case 'response.audio.delta':
        if (data['delta'] != null) {
          print('Received audio chunk, size: ${data['delta'].length}');
          final audioChunk = base64Decode(data['delta']);
          _audioBuffer.add(audioChunk);
        }
        break;

      case 'response.audio_transcript.delta':
        if (data['delta'] != null) {
          print('Received text delta: ${data['delta']}');
          setState(() => _assistantResponse += data['delta']);
        }
        break;

      case 'response.audio.done':
        print('Audio response completed, playing audio');
        if (_audioBuffer.isNotEmpty) {
          await _playCollectedAudio();
        }
        break;
    }
  }

  Future<void> _playAudioResponse(Uint8List audioData) async {
    try {
      // Add WAV header
      final wavData = _addWavHeader(audioData);

      // Create data source
      final audioSource = MemoryAudioSource(wavData);

      // Play audio
      await _audioPlayer?.setAudioSource(audioSource);
      await _audioPlayer?.play();
    } catch (e) {
      setState(() => _errorMessage = 'Playback error: ${e.toString()}');
    }
  }

  Future<void> _playCollectedAudio() async {
    print('Starting audio playback...');
    try {
      if (_audioBuffer.isEmpty) {
        print('Audio buffer is empty, nothing to play');
        return;
      }

      // Combine all audio chunks
      int totalLength = _audioBuffer.fold<int>(
        0,
        (sum, chunk) => sum + chunk.length,
      );
      print('Total audio length: $totalLength bytes');

      final combinedAudio = Uint8List(totalLength);
      int offset = 0;
      for (var chunk in _audioBuffer) {
        combinedAudio.setRange(offset, offset + chunk.length, chunk);
        offset += chunk.length;
      }

      // Add WAV header for 24kHz mono PCM16
      final wavData = _addWavHeader(combinedAudio);

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        '${tempDir.path}/response_${DateTime.now().millisecondsSinceEpoch}.wav',
      );
      await tempFile.writeAsBytes(wavData);
      print('Audio saved to: ${tempFile.path}');

      // Play the audio file
      await _audioPlayer?.setFilePath(tempFile.path);
      print('Audio source set');
      await _audioPlayer?.play();
      print('Audio playback started');

      // Clean up
      _audioPlayer?.processingStateStream.listen((state) {
        print('Audio player state: $state');
        if (state == ProcessingState.completed) {
          print('Audio playback completed');
          tempFile.delete();
          _audioBuffer.clear();
        }
      });
    } catch (e) {
      print('Error during audio playback: $e');
      setState(() => _errorMessage = 'Audio playback error: ${e.toString()}');
      _audioBuffer.clear();
    }
  }

  void _handleConnectionError(String error) {
    print('Connection error occurred: $error');
    if (mounted) {
      setState(() {
        _errorMessage = error;
        _isConnected = false;
      });
      _attemptReconnect();
    }
  }

  void _attemptReconnect() {
    print('Attempting to reconnect...');
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 2), () {
      if (mounted &&
          !_isConnected &&
          _reconnectAttempts < maxReconnectAttempts) {
        print(
          'Reconnection attempt ${_reconnectAttempts + 1} of $maxReconnectAttempts',
        );
        _reconnectAttempts++;
        _initializeOpenAI();
      }
    });
  }

  void _resetConnection() {
    print('Resetting connection...');
    _channel?.sink.close();
    _channel = null;
    _reconnectAttempts = 0;
    _audioBuffer.clear();
    if (mounted) {
      setState(() {
        _isConnected = false;
        _errorMessage = '';
      });
    }
    _initializeOpenAI();
  }

  @override
  void dispose() {
    _audioRecorder?.dispose();
    _audioPlayer?.dispose();
    _channel?.sink.close();
    _audioBuffer.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Connection status
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _isConnected
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _isConnected ? 'Connected' : 'Disconnected',
              style: TextStyle(color: _isConnected ? Colors.green : Colors.red),
            ),
          ),
          const SizedBox(height: 16),

          // Microphone button
          GestureDetector(
            onTapDown: (_) => _startRecording(),
            onTapUp: (_) => _stopRecording(),
            onTapCancel: () => _stopRecording(),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isRecording ? Colors.red : Colors.blue,
              ),
              child: Icon(
                _isRecording ? Icons.mic : Icons.mic_none,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // User transcript
          if (_lastTranscript.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'You said:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(_lastTranscript),
                ],
              ),
            ),
          const SizedBox(height: 8),

          // Assistant response
          if (_assistantResponse.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Assistant:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(_assistantResponse),
                ],
              ),
            ),

          // Error message
          if (_errorMessage.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}

// Custom PCM Audio Source
class PCMAudioSource extends StreamAudioSource {
  final Uint8List audioData;
  final int sampleRate;
  final int channels;
  final int bitsPerSample;
  final Endian endian;

  PCMAudioSource({
    required this.audioData,
    this.sampleRate = 24000,
    this.channels = 1,
    this.bitsPerSample = 16,
    this.endian = Endian.little,
  });

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    // Calculate the content length
    start = start ?? 0;
    end = end ?? audioData.length;

    // Create a stream from the audio data
    final stream = Stream.value(audioData.sublist(start, end));

    // Return the audio response
    return StreamAudioResponse(
      sourceLength: audioData.length,
      contentLength: end - start,
      offset: start,
      stream: stream,
      contentType: 'audio/raw',
    );
  }
}

class RawPCMAudioSource extends StreamAudioSource {
  final Uint8List bytes;

  RawPCMAudioSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;

    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/x-raw',
    );
  }
}

Uint8List _addWavHeader(Uint8List pcmData) {
  final int channelCount = 1;
  final int sampleRate = 24000;
  final int bitsPerSample = 16;
  final int byteRate = sampleRate * channelCount * (bitsPerSample ~/ 8);
  final int blockAlign = channelCount * (bitsPerSample ~/ 8);

  final header = ByteData(44); // WAV header is 44 bytes
  var offset = 0;

  // RIFF header
  header.setUint32(offset, 0x52494646, Endian.big); // "RIFF"
  offset += 4;
  header.setUint32(offset, 36 + pcmData.length, Endian.little);
  offset += 4;
  header.setUint32(offset, 0x57415645, Endian.big); // "WAVE"
  offset += 4;

  // fmt chunk
  header.setUint32(offset, 0x666D7420, Endian.big); // "fmt "
  offset += 4;
  header.setUint32(offset, 16, Endian.little); // fmt chunk size
  offset += 4;
  header.setUint16(offset, 1, Endian.little); // PCM format
  offset += 2;
  header.setUint16(offset, channelCount, Endian.little);
  offset += 2;
  header.setUint32(offset, sampleRate, Endian.little);
  offset += 4;
  header.setUint32(offset, byteRate, Endian.little);
  offset += 4;
  header.setUint16(offset, blockAlign, Endian.little);
  offset += 2;
  header.setUint16(offset, bitsPerSample, Endian.little);
  offset += 2;

  // data chunk
  header.setUint32(offset, 0x64617461, Endian.big); // "data"
  offset += 4;
  header.setUint32(offset, pcmData.length, Endian.little);

  final wavFile = Uint8List(44 + pcmData.length);
  wavFile.setRange(0, 44, header.buffer.asUint8List());
  wavFile.setRange(44, wavFile.length, pcmData);

  return wavFile;
}

class MemoryAudioSource extends StreamAudioSource {
  final Uint8List _buffer;

  MemoryAudioSource(this._buffer);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= _buffer.length;

    return StreamAudioResponse(
      sourceLength: _buffer.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(_buffer.sublist(start, end)),
      contentType: 'audio/wav',
    );
  }
}
