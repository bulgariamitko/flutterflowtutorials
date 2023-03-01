// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=_TCVr5R_i78
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

// how to compare two images using bytes, method 1
import 'dart:ui' as ui;
import 'dart:io';

Future<bool> compareImages(File image1, File image2) async {
  final data1 = await image1.readAsBytes();
  final data2 = await image2.readAsBytes();
  final image1Data = await decodeImageFromList(data1);
  final image2Data = await decodeImageFromList(data2);

  if (image1Data.width != image2Data.width || image1Data.height != image2Data.height) {
    return false;
  }

  final buffer1 = image1Data.toByteData();
  final buffer2 = image2Data.toByteData();

  for (int i = 0; i < buffer1.lengthInBytes; i++) {
    if (buffer1.getUint8(i) != buffer2.getUint8(i)) {
      return false;
    }
  }

  return true;
}

// how to compare two images using bytes, method 2
import 'dart:io';
import 'package:image/image.dart' as img;

Future<bool> compareImages(File image1, File image2) async {
  final data1 = await image1.readAsBytes();
  final data2 = await image2.readAsBytes();
  final hash1 = img.Image.fromBytes(1, 1, data1).hashCode;
  final hash2 = img.Image.fromBytes(1, 1, data2).hashCode;
  return hash1 == hash2;
}


// using the noise_meter package
import 'package:noise_meter/noise_meter.dart';

class Noise extends StatefulWidget {
  const Noise({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _NoiseState createState() => _NoiseState();
}

class _NoiseState extends State<Noise> {
  bool _isRecording = false;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  late NoiseMeter _noiseMeter;

  @override
  void initState() {
    super.initState();
    _noiseMeter = new NoiseMeter(onError);
  }

  @override
  void dispose() {
    _noiseSubscription?.cancel();
    super.dispose();
  }

  void onData(NoiseReading noiseReading) {
    this.setState(() {
      if (!this._isRecording) {
        this._isRecording = true;
      }
    });
    print(noiseReading.toString());
  }

  void onError(Object error) {
    print(error.toString());
    _isRecording = false;
  }

  void start() async {
    try {
      _noiseSubscription = _noiseMeter.noiseStream.listen(onData);
    } catch (err) {
      print(err);
    }
  }

  void stop() async {
    try {
      if (_noiseSubscription != null) {
        _noiseSubscription!.cancel();
        _noiseSubscription = null;
      }
      this.setState(() {
        this._isRecording = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  List<Widget> getContent() => <Widget>[
        Container(
            margin: EdgeInsets.all(25),
            child: Column(children: [
              Container(
                child: Text(_isRecording ? "Mic: ON" : "Mic: OFF",
                    style: TextStyle(fontSize: 25, color: Colors.blue)),
                margin: EdgeInsets.only(top: 20),
              )
            ])),
      ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: getContent())),
        floatingActionButton: FloatingActionButton(
            backgroundColor: _isRecording ? Colors.red : Colors.green,
            onPressed: _isRecording ? stop : start,
            child: _isRecording ? Icon(Icons.stop) : Icon(Icons.mic)),
      ),
    );
  }
}


// uisng google_maps_flutter package
import 'dart:math' show cos, sqrt, asin;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' hide LatLng;
import 'package:google_maps_flutter/google_maps_flutter.dart' as latlng;

class RouteViewStatic extends StatefulWidget {
  const RouteViewStatic({
    Key? key,
    this.width,
    this.height,
    this.lineColor = Colors.black,
    this.startAddress,
    this.destinationAddress,
    required this.startCoordinate,
    required this.endCoordinate,
    required this.iOSGoogleMapsApiKey,
    required this.androidGoogleMapsApiKey,
    required this.webGoogleMapsApiKey,
  }) : super(key: key);

  final double? height;
  final double? width;
  final Color lineColor;
  final String? startAddress;
  final String? destinationAddress;
  final LatLng startCoordinate;
  final LatLng endCoordinate;
  final String iOSGoogleMapsApiKey;
  final String androidGoogleMapsApiKey;
  final String webGoogleMapsApiKey;

  @override
  _RouteViewStaticState createState() => _RouteViewStaticState();
}

class _RouteViewStaticState extends State<RouteViewStatic> {
  // TODO: Add variables here
  // TODO: Add the methods here

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}