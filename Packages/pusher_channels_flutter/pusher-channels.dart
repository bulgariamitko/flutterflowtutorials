// YouTube channel - https://www.youtube.com/@dimitarklaturov
// paid video - https://youtu.be/daLWoRHOXR0
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

Future<void> initializePusher(String channelName) async {
  try {
    await pusher.init(
      apiKey: 'YOUR_KEY',
      cluster: 'YOUR_CLUSTER',
      onConnectionStateChange: onConnectionStateChange,
      onError: onError,
    );

    await pusher.subscribe(
      channelName: channelName,
      onEvent: (event) =>
          onEvent(event), // Ensure the event handler matches the expected type
    );

    await pusher.connect();
    FFAppState().update(() {
      FFAppState().status = 'Connected';
    });
    print("Pusher initialized successfully.");
  } catch (e) {
    print("Error initializing Pusher: $e");
  }
}

void onEvent(PusherEvent event) {
  print("Event received: ${event.eventName}");
  print("Event data: ${event.data}");
  FFAppState().update(() {
    FFAppState().message = event.data;
  });
}

void onConnectionStateChange(dynamic currentState, dynamic previousState) {
  print("Connection state changed: $currentState");
}

void onError(String message, int? code, dynamic e) {
  print("Pusher error: $message, code: $code, exception: $e");
}
