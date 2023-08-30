// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=rrgw84My5tw
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

import 'dart:math';
import 'dart:convert';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:download/download.dart';

import '../actions/widget_to_image.dart';
import '../actions/add_to_num.dart';

class QRCodeDownloader extends StatefulWidget {
  const QRCodeDownloader({
    Key? key,
    this.width,
    this.height,
    this.data,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? data;

  @override
  _QRCodeDownloaderState createState() => _QRCodeDownloaderState();
}

class _QRCodeDownloaderState extends State<QRCodeDownloader> {
  // Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  static Uint8List generateRandomUint8List(int length) {
    final random = Random();
    final List<int> bytes = List.generate(length, (_) => random.nextInt(256));
    return Uint8List.fromList(bytes);
  }

  Uint8List capturedImage = Uint8List(0); // Initialize an empty Uint8List

  @override
  void initState() {
    super.initState();
    _updateCapturedImage();
  }

  Future<void> _updateCapturedImage() async {
    // Capture the screenshot of the QR code widget
    Uint8List image =
        await screenshotController.capture() ?? generateRandomUint8List(1);

    setState(() {
      capturedImage = image;
    });

    FFAppState().update(() {
      FFAppState().widgetToExport = base64.encode(capturedImage);
    });

    await addToNum();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Screenshot(
          controller: screenshotController,
          child: QrImageView(
            data: widget.data ?? 'No data',
            version: QrVersions.auto,
            size: 320,
            gapless: false,
          ),
        ),
      ],
    );
  }
}