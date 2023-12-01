// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=5VtUTZ5nyDU
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

// Note: This code can be used as a custom function as well


Future<String> countDownTimer(String? mins, String? secs) async {
  // null safety
  int minutes = int.tryParse(mins ?? '1') ?? 1;
  int seconds = int.tryParse(secs ?? '0') ?? 0;

  FFAppState().update(() {
    FFAppState().timerRunning = true;
  });

  // Convert total time to seconds
  int totalSeconds = minutes * 60 + seconds;

  // Countdown loop
  while (totalSeconds > 0) {
    if (FFAppState().timerPaused) {
      FFAppState().update(() {
        FFAppState().timerRunning = false;
      });
      break;
    }

    // Decrement the time
    totalSeconds--;

    // Calculate the current minutes and seconds
    int currentMinutes = totalSeconds ~/ 60;
    int currentSeconds = totalSeconds % 60;

    // Format minutes and seconds as two digits
    String formattedMinutes = currentMinutes.toString().padLeft(2, '0');
    String formattedSeconds = currentSeconds.toString().padLeft(2, '0');

    // Print current time (optional, for demonstration)
    FFAppState().update(() {
      FFAppState().timer = '$formattedMinutes:$formattedSeconds';
      FFAppState().mins = formattedMinutes;
      FFAppState().secs = formattedSeconds;
    });
    print('Time left: $formattedMinutes mins, $formattedSeconds secs');

    // Wait for a second before continuing the loop
    await Future.delayed(Duration(seconds: 1));
  }

  FFAppState().update(() {
    FFAppState().timerRunning = false;
  });

  return 'Time is up!';
}
