// code created by https://www.youtube.com/@flutterflowexpert

import 'dart:math';

Future shuffleNames(List<UsersRecord>? users) async {
  users = users ?? [];
  int randomIndex = Random().nextInt(users.length);
  FFAppState().shuffleNames = users[randomIndex].displayName ?? '';
  FFAppState().winnerRef = users[randomIndex].reference;
  print(users[randomIndex]);
}