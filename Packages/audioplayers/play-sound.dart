// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

File? _tempFile;
Future<void> playSoundFromBytes(String bytes) async {
  try {
    // Convert the String of bytes to Uint8List
    Uint8List audioBytes = Uint8List.fromList(bytes.codeUnits);

    // Create a temporary file to store the audio data
    final tempDir = await getTemporaryDirectory();
    _tempFile = File('${tempDir.path}/temp_audio.mp3');
    await _tempFile!.writeAsBytes(audioBytes);

    // Create an AudioPlayer instance
    FFAppState().audioPlayerPlayingMsg = AudioPlayer();

    // Set playing state to true before starting playback
    FFAppState().update(() {
      FFAppState().audioPlaying = true;
    });

    // Listen to player state changes
    FFAppState()
        .audioPlayerPlayingMsg!
        .onPlayerStateChanged
        .listen((PlayerState state) {
      if (state == PlayerState.completed || state == PlayerState.stopped) {
        print('completed - FFAppState().audioPlaying = false;');
        FFAppState().update(() {
          FFAppState().audioPlaying = false;
        });
      } else if (state == PlayerState.playing) {
        print('completed - FFAppState().audioPlaying = true;');
        FFAppState().update(() {
          FFAppState().audioPlaying = true;
        });
      }
    });

    // Play the audio from the temporary file
    await FFAppState()
        .audioPlayerPlayingMsg!
        .play(DeviceFileSource(_tempFile!.path));

    // Wait for the audio to finish playing
    await FFAppState().audioPlayerPlayingMsg!.onPlayerComplete.first;

    // Set playing state to false after completion
    FFAppState().update(() {
      FFAppState().audioPlaying = false;
    });

    // Clean up
    await _cleanup();
  } catch (e) {
    print('Error playing sound: $e');
    FFAppState().update(() {
      FFAppState().audioPlaying = false;
    });
    await _cleanup();
  }
}

Future<void> _cleanup() async {
  // Stop and dispose of the player
  await FFAppState().audioPlayerPlayingMsg?.dispose();
  FFAppState().audioPlayerPlayingMsg = null;

  // Delete the temporary file
  await _tempFile?.delete();
  _tempFile = null;
}
