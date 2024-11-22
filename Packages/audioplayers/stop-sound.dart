// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

Future stopSound() async {
  try {
    // Stop and dispose the current audio player if it exists
    if (FFAppState().audioPlayerPlayingMsg != null) {
      await FFAppState().audioPlayerPlayingMsg?.stop();
      await FFAppState().audioPlayerPlayingMsg?.dispose();
      FFAppState().audioPlayerPlayingMsg = null;
      // Set playing state to false when stopped
      FFAppState().update(() {
        FFAppState().audioPlaying = false;
      });
      print('FFAppState().audioPlaying = false;');
    }

    // Clean up the temp file if it exists
    // if (_tempFile != null) {
    //   await _tempFile?.delete();
    //   _tempFile = null;
    // }
  } catch (e) {
    print('Error stopping audio: $e');
    FFAppState().update(() {
      FFAppState().audioPlaying = false;
    });
  }
}
