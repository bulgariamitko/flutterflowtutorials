// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async'; // Import Dart's async library for stream subscription management

Future countSteps() async {
  if (!await _requestPermissions()) return;

  // Define stream subscriptions at the class level for better management
  StreamSubscription<StepCount>? _stepCountSubscription;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;

  // Initialize streams
  final _stepCountStream = Pedometer.stepCountStream;
  final _pedestrianStatusStream = Pedometer.pedestrianStatusStream;

  // Listen to the step count stream and handle errors separately
  _stepCountSubscription = _stepCountStream.listen(_onStepCount);
  _stepCountSubscription.onError(_onStepCountError);

  // Listen to the pedestrian status stream and handle errors separately
  _pedestrianStatusSubscription =
      _pedestrianStatusStream.listen(_onPedestrianStatusChanged);
  _pedestrianStatusSubscription.onError(_onPedestrianStatusError);

  // Add disposal logic as needed, for example:
  // @override
  // void dispose() {
  //   _stepCountSubscription?.cancel();
  //   _pedestrianStatusSubscription?.cancel();
  //   super.dispose();
  // }
}

Future<bool> _requestPermissions() async {
  final status = await Permission.activityRecognition.request();
  return status == PermissionStatus.granted;
}

void _onStepCount(StepCount event) {
  // Update your state directly here
  // Assuming FFAppState().update is a valid method to update your state
  FFAppState().update(() {
    FFAppState().steps = event.steps;
    FFAppState().stepsTime = event.timeStamp;
  });
}

void _onPedestrianStatusChanged(PedestrianStatus event) {
  // Update your state directly here
  FFAppState().update(() {
    FFAppState().status = event.status;
    FFAppState().statusTime = event.timeStamp;
  });
}

void _onPedestrianStatusError(error) {
  // Handle pedestrian status stream error
  print('Pedestrian status update error: $error');
}

void _onStepCountError(error) {
  // Handle step count stream error
  print('Step count update error: $error');
}
