// YouTube channel - https://www.youtube.com/@dimitarklaturov
// paid video - https://www.youtube.com/watch?v=idXHYU0co5Y
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'package:call_log/call_log.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> getOldPhoneCalls(
  Future Function(PhoneCallStruct oldCall) oldPhoneCall,
) async {
  print('Starting to retrieve old phone calls...');

  // Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  // Request permission if not already granted
  print('Checking phone permission...');
  var status = await Permission.phone.status;
  if (!status.isGranted) {
    status = await Permission.phone.request();
    print('Permission status after request: $status');
    if (!status.isGranted) {
      print('Phone permission denied');
      return;
    }
  }
  print('Phone permission granted');

  try {
    // Get all call log entries
    print('Retrieving call log entries...');
    Iterable<CallLogEntry> entries = await CallLog.get();
    print('Found ${entries.length} call log entries');

    // Process each call log entry
    for (final entry in entries) {
      print('Processing call entry: ${entry.number}');

      final oldCallData = PhoneCallStruct(
        type: CallType.values[entry.callType!.index].toString().split('.').last,
        number: entry.number ?? '',
        timestamp: entry.timestamp.toString(),
        duration: entry.duration.toString(),
      );

      print(
        'Executing callback for call: ${oldCallData.type} - ${oldCallData.number}',
      );
      await oldPhoneCall(oldCallData);
    }

    print('Finished processing all old calls');
  } catch (e) {
    print('Error retrieving old calls: $e');
    rethrow;
  }
}
