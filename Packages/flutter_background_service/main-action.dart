// code created by https://www.youtube.com/@flutterflowexpert
// future video - https://www.youtube.com/watch?v=oJDkoYfVA1g
// widgets - Cg9Db2x1bW5fd2ZjOWVlcHUS0AEKD0J1dHRvbl9qNTZ4MTN4bhgJIn1KeAoZCg1HZXQgUGhvbmUgbG9nOgYI/////w9ABRkAAAAAAAAIQDEAAAAAAABEQEkAAAAAAADwP1ICEAFaAggAciQJAAAAAAAAIEARAAAAAAAAIEAZAAAAAAAAIEAhAAAAAAAAIEB6EgkAAAAAAAA4QBkAAAAAAAA4QPoDAGIAigE5EjMKCHRvbDhyaDF2EifSARkKFQoMcmVhZFBob25lTG9nEgV4ZDhyYiIAqgIIN3ZiZmlxY2waAggBEkUKDVRleHRfdzkxNDVtMngYAiIwEhIKC0hlbGxvIFdvcmxkQAaoAQCaARYKAgIBKhAIDEIMIgoKBgoEdHlwZRAB+gMAYgASRwoNVGV4dF9jcW4zY241YRgCIjISEgoLSGVsbG8gV29ybGRABqgBAJoBGAoCAgEqEggMQg4iDAoICgZudW1iZXIQAfoDAGIAEkkKDVRleHRfamZ6bTc5cDQYAiI0EhIKC0hlbGxvIFdvcmxkQAaoAQCaARoKAgIBKhQIDEIQIg4KCgoIZHVyYXRpb24QAfoDAGIAEkoKDVRleHRfY2FsNHZ5N2QYAiI1EhIKC0hlbGxvIFdvcmxkQAaoAQCaARsKAgIBKhUIDEIRIg8KCwoJdGltZXN0YW1wEAH6AwBiABKfBAoPQnV0dG9uX2xrbDJldzdzGAkijgJKggEKIwoXc3RhcnQgYmFja2dyb3VuZCBhY3Rpb246Bgj/////D0AFGQAAAAAAAAhAMQAAAAAAAERASQAAAAAAAPA/UgIQAVoCCAByJAkAAAAAAAAgQBEAAAAAAAAgQBkAAAAAAAAgQCEAAAAAAAAgQHoSCQAAAAAAADhAGQAAAAAAADhAmgGCAQoDCQEBKnsIClJ3OnUKUAowCApSLBIcEhoIDEIWIhQKEAoOc2VydmljZVJ1bm5pbmcQARIICgYSBHRydWUiAggBEhwKGhIYU3RvcCBiYWNrZ3JvdW5kIHNlcnZpY2VzEh0KGxIZU3RhcnQgYmFja2dyb3VuZCBzZXJ2aWNlcxoCEAP6AwBiAIoB9QES7gEKCGNhdzdmeXVkGq4BGjwKCG54eXJrMWtyEjDiASJCHAoQCg5zZXJ2aWNlUnVubmluZxIICgYSBHRydWVQAlgBqgIIMjZhYXIzcTYibAoyCjAIClIsEhwSGggMQhYiFAoQCg5zZXJ2aWNlUnVubmluZxABEggKBhIEdHJ1ZSICCAESNgoIenE0OGJobGkSKuIBHEIWChAKDnNlcnZpY2VSdW5uaW5nEgIKAFACWAGqAgh0NzRmaWtseCgAKjEKCHJjOHczeGYxEiXSARcKEwoKbWFpbkFjdGlvbhIFNXV3amciAKoCCHR6a2l6cWN5GgIIARgEIgciAhAB+gMA
// support my work - https://github.com/sponsors/bulgariamitko

import 'dart:isolate';
import 'dart:ui';

// import '../../backend/api_requests/api_calls.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:call_log/call_log.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future mainAction() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request permission before starting the service
  await requestPhonePermission();

  await initializeService();
}

Future<void> initializeService() async {
  if (isAndroid) {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'your_notification_channel_id', // id
      'Your Notification Channel', // title
      importance: Importance.high,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  final service = FlutterBackgroundService();

  // Configure the service as necessary
  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      // This will be executed when the app is in foreground or background in a separate isolate
      onStart: onStart,

      // Auto start service
      autoStart: true,
      isForegroundMode: true,

      // Add necessary notification details
      notificationChannelId: 'your_notification_channel_id',
      initialNotificationTitle: 'Your Service Title',
      initialNotificationContent: 'Your Service Content',
      foregroundServiceNotificationId: 1,
    ),
  );
}

Future<void> onStart(ServiceInstance service) async {
  ReceivePort receivePort = ReceivePort();
  IsolateNameServer.removePortNameMapping('ServiceRunningPort');
  IsolateNameServer.registerPortWithName(
      receivePort.sendPort, 'ServiceRunningPort');
  receivePort.listen((message) {
    if (message == 'STOP') {
      service.stopSelf();
      IsolateNameServer.removePortNameMapping('ServiceRunningPort');
    }
  });

  while (true) {
    final now = DateTime.now();
    if (now.hour >= 8 && now.hour <= 19) {
      await readPhoneLog();
    }
    await Future.delayed(Duration(minutes: 1));
  }
}

List<String> phoneLogs = [];
List<String> types = [];
List<String> numbers = [];
List<String> durations = [];
List<String> timestamps = [];

Future readPhoneLog() async {
  Iterable<CallLogEntry> entries = await CallLog.get();

  for (final entry in entries) {
    // Converting enum to string
    String callType =
        CallType.values[entry.callType!.index].toString().split('.').last;

    // Converting the integer timestamp (milliseconds since epoch) to DateTime
    DateTime date = DateTime.fromMillisecondsSinceEpoch(entry.timestamp ?? 0);

    // Formatting timestamp to string
    String timestamp = DateFormat('yyyy-MM-dd – kk:mm').format(date);

    String phoneLog =
        callType + (entry.number ?? '') + entry.duration.toString() + timestamp;

    // If this phone log is not in the set yet, add it to the set and process it.
    if (!phoneLogs.contains(phoneLog)) {
      phoneLogs.add(phoneLog);

      types.add(callType);
      numbers.add(entry.number ?? '');
      durations.add(entry.duration.toString());
      timestamps.add(timestamp);

      FFAppState().update(() {
        FFAppState().type = callType;
        FFAppState().number = entry.number ?? '';
        FFAppState().duration = entry.duration.toString();
        FFAppState().timestamp = timestamp;
      });
    }
  }
  if (types.isNotEmpty) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone = prefs.getString('phone') ?? '';

    // await SendPhoneCallsCall.call(
    //     typesList: types,
    //     numbersList: numbers,
    //     durationsList: durations,
    //     timestampsList: timestamps,
    //     phone: phone);

  }

  types = [];
  numbers = [];
  durations = [];
  timestamps = [];
}

Future<void> requestPhonePermission() async {
  var status = await Permission.phone.status;
  if (!status.isGranted) {
    status = await Permission.phone.request();
    if (!status.isGranted) {
      // Optionally, you can prompt a dialog here to inform user about the necessity of the permission
    }
  }
}
