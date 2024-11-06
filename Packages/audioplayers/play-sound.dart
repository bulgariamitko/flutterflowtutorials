// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/widgets.dart';

AudioPlayer? _player;
File? _tempFile;

Future<void> playSoundFromBytes(BuildContext context, String bytes) async {
  try {
    // Convert the String of bytes to Uint8List
    Uint8List audioBytes = Uint8List.fromList(bytes.codeUnits);

    // Create a temporary file to store the audio data
    final tempDir = await getTemporaryDirectory();
    _tempFile = File('${tempDir.path}/temp_audio.mp3');
    await _tempFile!.writeAsBytes(audioBytes);

    // Create an AudioPlayer instance
    _player = AudioPlayer();

    // Play the audio from the temporary file
    await _player!.play(DeviceFileSource(_tempFile!.path));

    // Set up a listener for app lifecycle changes
    WidgetsBinding.instance.addObserver(_LifecycleObserver());

    // Set up a listener for route changes
    WidgetsBinding.instance.addObserver(_RouteObserver());

    // Wait for the audio to finish playing
    await _player!.onPlayerComplete.first;

    // Clean up
    await _cleanup();
  } catch (e) {
    print('Error playing sound: $e');
    await _cleanup();
  }
}

void _stopAudio() {
  _player?.stop();
}

Future<void> _cleanup() async {
  // Stop and dispose of the player
  await _player?.stop();
  await _player?.dispose();
  _player = null;

  // Delete the temporary file
  await _tempFile?.delete();
  _tempFile = null;

  // Remove the observers
  WidgetsBinding.instance.removeObserver(_LifecycleObserver());
  WidgetsBinding.instance.removeObserver(_RouteObserver());
}

class _LifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _stopAudio();
    }
  }
}

class _RouteObserver extends WidgetsBindingObserver {
  @override
  Future<bool> didPushRoute(String route) {
    _stopAudio();
    return Future<bool>.value(false);
  }

  @override
  Future<bool> didPopRoute() {
    _stopAudio();
    return Future<bool>.value(false);
  }
}
