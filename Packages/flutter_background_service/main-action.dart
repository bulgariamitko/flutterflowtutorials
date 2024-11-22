// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=idXHYU0co5Y
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'dart:isolate';
import 'dart:ui';
import 'package:call_log/call_log.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:telephony/telephony.dart';

// Global callback storage
Future Function(PhoneCallStruct)? _globalPhoneCallback;
Future Function(SmsStruct)? _globalSmsCallback;

// Create notification channel
Future<void> setupNotificationChannel() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'phone_monitor_channel',
    'Phone & SMS Monitor',
    description: 'Monitors for phone calls and SMS messages',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

// Top-level function for background service
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  print('Background service started!');

  // Set up communication port
  ReceivePort receivePort = ReceivePort();
  IsolateNameServer.removePortNameMapping('ServiceRunningPort');
  IsolateNameServer.registerPortWithName(
      receivePort.sendPort, 'ServiceRunningPort');

  receivePort.listen((message) {
    print('Received message in background: $message');
    if (message == 'STOP') {
      service.stopSelf();
      IsolateNameServer.removePortNameMapping('ServiceRunningPort');
    }
  });

  // Initialize Telephony instance for SMS monitoring
  final telephony = Telephony.instance;

  // Get initial timestamps to only process new events
  int startCallTimestamp = DateTime.now().millisecondsSinceEpoch;
  int startSmsTimestamp = startCallTimestamp;
  print('Initial timestamp: $startCallTimestamp');

  while (true) {
    try {
      // Check for new calls
      print('Checking for new calls...');
      Iterable<CallLogEntry> callEntries = await CallLog.get();
      print('Found ${callEntries.length} call log entries');

      for (final entry in callEntries) {
        if (entry.timestamp != null && entry.timestamp! > startCallTimestamp) {
          print('New call detected! Timestamp: ${entry.timestamp}');

          final newCall = PhoneCallStruct(
            type: CallType.values[entry.callType!.index]
                .toString()
                .split('.')
                .last,
            number: entry.number ?? '',
            timestamp: entry.timestamp.toString(),
            duration: entry.duration.toString(),
          );

          print(
              'Sending call data to main isolate: ${newCall.type} - ${newCall.number}');
          service.invoke(
            'onNewCall',
            {
              'type': newCall.type,
              'number': newCall.number,
              'timestamp': newCall.timestamp,
              'duration': newCall.duration,
            },
          );

          startCallTimestamp = entry.timestamp!;
        }
      }

      // Check for new SMS messages
      print('Checking for new SMS messages...');
      List<SmsMessage> smsMessages = await telephony.getInboxSms(
        columns: [
          SmsColumn.ID,
          SmsColumn.ADDRESS,
          SmsColumn.BODY,
          SmsColumn.DATE,
          SmsColumn.DATE_SENT,
          SmsColumn.READ,
          SmsColumn.SEEN,
          SmsColumn.STATUS,
          SmsColumn.TYPE,
        ],
      );

      for (final sms in smsMessages) {
        if (sms.date != null && sms.date! > startSmsTimestamp) {
          print('New SMS detected! Timestamp: ${sms.date}');

          service.invoke(
            'onNewSms',
            {
              'id': sms.id ?? 0,
              'address': sms.address ?? '',
              'body': sms.body ?? '',
              'date': sms.date ?? 0,
              'dateSent': sms.dateSent ?? 0,
              'read': sms.read ?? false,
              'seen': sms.seen ?? false,
              'status': sms.status?.name ?? 'none',
              'type': sms.type?.name ?? 'received',
            },
          );

          startSmsTimestamp = sms.date!;
        }
      }

      await Future.delayed(Duration(seconds: 30));
    } catch (e) {
      print('Error monitoring events: $e');
      await Future.delayed(Duration(seconds: 30));
    }
  }
}

Future startPhoneCallMonitor(
  Future Function(PhoneCallStruct callData) phoneCallData,
  Future Function(SmsStruct smsData) smsCallData,
) async {
  print('Starting phone and SMS monitor...');

  WidgetsFlutterBinding.ensureInitialized();
  _globalPhoneCallback = phoneCallData;
  _globalSmsCallback = smsCallData;

  // Setup notification channel
  print('Setting up notification channel...');
  await setupNotificationChannel();

  // Request permissions
  print('Requesting permissions...');
  var phoneStatus = await Permission.phone.status;
  var smsStatus = await Permission.sms.status;

  if (!phoneStatus.isGranted) {
    phoneStatus = await Permission.phone.request();
  }

  if (!smsStatus.isGranted) {
    smsStatus = await Permission.sms.request();
  }

  // Request notification permission
  var notificationStatus = await Permission.notification.status;
  if (!notificationStatus.isGranted) {
    await Permission.notification.request();
  }

  // Initialize and start background service
  final service = FlutterBackgroundService();

  // Set up event listeners
  service.on('onNewCall').listen((event) async {
    print('Received call event in main isolate: $event');
    if (event != null && _globalPhoneCallback != null) {
      final newCall = PhoneCallStruct(
        type: event['type'] as String,
        number: event['number'] as String,
        timestamp: event['timestamp'] as String,
        duration: event['duration'] as String,
      );
      print(
          'Executing callback with call data: ${newCall.type} - ${newCall.number}');
      await _globalPhoneCallback!(newCall);
    }
  });

  service.on('onNewSms').listen((event) async {
    print('Received SMS event in main isolate: $event');
    if (event != null && _globalSmsCallback != null) {
      final newSms = SmsStruct(
        id: event['id'] as int,
        address: event['address'] as String,
        body: event['body'] as String,
        date: event['date'] as int,
        dateSent: event['dateSent'] as int,
        read: event['read'] as bool,
        seen: event['seen'] as bool,
        status: event['status'] as String,
        type: event['type'] as String,
      );
      print(
          'Executing callback with SMS data: ${newSms.address} - ${newSms.body.substring(0, min(20, newSms.body.length))}...');
      await _globalSmsCallback!(newSms);
    }
  });

  print('Configuring background service...');
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'phone_monitor_channel',
      initialNotificationTitle: 'Phone & SMS Monitor',
      initialNotificationContent: 'Monitoring for new calls and messages',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(),
  );

  bool isRunning = await service.isRunning();
  print('Background service running status: $isRunning');

  return isRunning;
}
