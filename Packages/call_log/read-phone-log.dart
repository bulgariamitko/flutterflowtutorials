// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=oJDkoYfVA1g
// widgets - Cg9Db2x1bW5fd2ZjOWVlcHUS0AEKD0J1dHRvbl9qNTZ4MTN4bhgJIn1KeAoZCg1HZXQgUGhvbmUgbG9nOgYI/////w9ABRkAAAAAAAAIQDEAAAAAAABEQEkAAAAAAADwP1ICEAFaAggAciQJAAAAAAAAIEARAAAAAAAAIEAZAAAAAAAAIEAhAAAAAAAAIEB6EgkAAAAAAAA4QBkAAAAAAAA4QPoDAGIAigE5EjMKCHRvbDhyaDF2EifSARkKFQoMcmVhZFBob25lTG9nEgV4ZDhyYiIAqgIIN3ZiZmlxY2waAggBEkUKDVRleHRfdzkxNDVtMngYAiIwEhIKC0hlbGxvIFdvcmxkQAaoAQCaARYKAgIBKhAIDEIMIgoKBgoEdHlwZRAB+gMAYgASRwoNVGV4dF9jcW4zY241YRgCIjISEgoLSGVsbG8gV29ybGRABqgBAJoBGAoCAgEqEggMQg4iDAoICgZudW1iZXIQAfoDAGIAEkkKDVRleHRfamZ6bTc5cDQYAiI0EhIKC0hlbGxvIFdvcmxkQAaoAQCaARoKAgIBKhQIDEIQIg4KCgoIZHVyYXRpb24QAfoDAGIAEkoKDVRleHRfY2FsNHZ5N2QYAiI1EhIKC0hlbGxvIFdvcmxkQAaoAQCaARsKAgIBKhUIDEIRIg8KCwoJdGltZXN0YW1wEAH6AwBiABKfBAoPQnV0dG9uX2xrbDJldzdzGAkijgJKggEKIwoXc3RhcnQgYmFja2dyb3VuZCBhY3Rpb246Bgj/////D0AFGQAAAAAAAAhAMQAAAAAAAERASQAAAAAAAPA/UgIQAVoCCAByJAkAAAAAAAAgQBEAAAAAAAAgQBkAAAAAAAAgQCEAAAAAAAAgQHoSCQAAAAAAADhAGQAAAAAAADhAmgGCAQoDCQEBKnsIClJ3OnUKUAowCApSLBIcEhoIDEIWIhQKEAoOc2VydmljZVJ1bm5pbmcQARIICgYSBHRydWUiAggBEhwKGhIYU3RvcCBiYWNrZ3JvdW5kIHNlcnZpY2VzEh0KGxIZU3RhcnQgYmFja2dyb3VuZCBzZXJ2aWNlcxoCEAP6AwBiAIoB9QES7gEKCGNhdzdmeXVkGq4BGjwKCG54eXJrMWtyEjDiASJCHAoQCg5zZXJ2aWNlUnVubmluZxIICgYSBHRydWVQAlgBqgIIMjZhYXIzcTYibAoyCjAIClIsEhwSGggMQhYiFAoQCg5zZXJ2aWNlUnVubmluZxABEggKBhIEdHJ1ZSICCAESNgoIenE0OGJobGkSKuIBHEIWChAKDnNlcnZpY2VSdW5uaW5nEgIKAFACWAGqAgh0NzRmaWtseCgAKjEKCHJjOHczeGYxEiXSARcKEwoKbWFpbkFjdGlvbhIFNXV3amciAKoCCHR6a2l6cWN5GgIIARgEIgciAhAB+gMA
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'package:call_log/call_log.dart';
import 'package:permission_handler/permission_handler.dart';

Future readPhoneLog() async {
  if (await Permission.phone.request().isGranted) {
    Iterable<CallLogEntry> entries = await CallLog.get();

    entries.forEach((entry) {
      // Converting enum to string
      String callType =
          CallType.values[entry.callType!.index].toString().split('.').last;

      // Converting the integer timestamp (milliseconds since epoch) to DateTime
      DateTime date = DateTime.fromMillisecondsSinceEpoch(entry.timestamp ?? 0);

      // Formatting timestamp to string
      String timestamp = DateFormat('yyyy-MM-dd – kk:mm').format(date);

      FFAppState().update(() {
        FFAppState().type = callType;
        FFAppState().number = entry.number ?? '';
        FFAppState().duration = entry.duration.toString();
        FFAppState().timestamp = timestamp;
      });
    });
  }
}
