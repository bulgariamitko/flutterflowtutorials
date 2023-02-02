// code created by https://www.youtube.com/@flutterflowexpert
// video - https://youtu.be/f3enSdgZ6oU
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

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