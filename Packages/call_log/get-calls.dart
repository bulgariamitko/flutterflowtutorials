// code created by https://www.youtube.com/@flutterflowexpert
// future video - no
// support my work - https://github.com/sponsors/bulgariamitko


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
