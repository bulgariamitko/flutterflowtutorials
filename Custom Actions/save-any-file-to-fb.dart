// code created by https://www.youtube.com/@flutterflowexpert
// video - https://youtube.com/watch?v=y5GfG-eX1QM
// support my work - https://github.com/sponsors/bulgariamitko

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../auth/firebase_auth/auth_util.dart';
import '../../backend/firebase_storage/storage.dart';

Future<String> uploadFileToLocalAndWeb(String? url) async {
  // null safety
  url ??= '';

  final response = await http.get(Uri.parse(url));
  final bytes = response.bodyBytes;

  final fileName = Uri.parse(url).pathSegments.last;
  String dir = '/users/' + currentUserUid + '/';
  final filePath = dir + fileName;

  final downloadUrl = await uploadData(filePath, bytes);

  return downloadUrl ?? '';
}