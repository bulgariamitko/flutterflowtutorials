// code created by https://www.youtube.com/@flutterflowexpert
// video - https://youtube.com/watch?v=f3enSdgZ6oU
// support my work - https://github.com/sponsors/bulgariamitko

import 'dart:math';

Future shuffleNames(List<ShuffingRecord>? users) async {
  // null safety
  users = users ?? [];

  int randomIndex = Random().nextInt(users.length);
  FFAppState().update(() {
    FFAppState().shuffleNames = users![randomIndex].name ?? '';
    FFAppState().winnerRef = users[randomIndex].reference;
  });
}