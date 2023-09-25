// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=rrgw84My5tw
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

import 'dart:math';

import 'package:screenshot/screenshot.dart';
import 'package:download/download.dart';

class WidgetToImage extends StatefulWidget {
  const WidgetToImage({
    Key? key,
    this.width,
    this.height,
    // this.data,
  }) : super(key: key);

  final double? width;
  final double? height;
  // final String? data;


  @override
  _WidgetToImageState createState() => _WidgetToImageState();
}

class _WidgetToImageState extends State<WidgetToImage> {
  // Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  // Function to generate a random Uint8List of a given length
  static Uint8List generateRandomUint8List(int length) {
    final random = Random();
    final List<int> bytes = List.generate(length, (_) => random.nextInt(256));
    return Uint8List.fromList(bytes);
  }

  Future<void> captureAndDownloadFromWidget() async {
    // Capture the screenshot of the QR code widget
    Uint8List image =
        await screenshotController.capture() ?? generateRandomUint8List(1);

    // METHOD 3
    // // Convert Uint8List to Blob
    // final blob = html.Blob([image]);

    // // Create a URL for the Blob
    // final url = html.Url.createObjectUrlFromBlob(blob);

    // // Create an anchor element and set the download URL
    // final anchor = html.AnchorElement(href: url)
    //   ..setAttribute("download", "qr_code.png");

    // // Trigger the download by clicking the anchor element
    // anchor.click();

    // // Revoke the URL to release resources
    // html.Url.revokeObjectUrl(url);

    // // Show a snackbar to indicate successful download
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Image downloaded successfully.'),
    //   ),
    // );

    // METHOD 2
    final fileName = "widget" + DateTime.now().toString() + ".png";

    final stream = Stream.fromIterable(image);
    download(stream, fileName);

    // METHOD 1
    // // Get the path of the external storage directory
    // final directory = await getExternalStorageDirectory();
    // if (directory == null) {
    //   print('Error: External storage directory not available.');
    //   return;
    // }

    // // Create a new File in the external storage directory
    // final file = File('${directory.path}/qr_code.png');

    // // Write the image data to the file
    // await file.writeAsBytes(image);

    // print('Image downloaded and saved successfully.');

    // // Show a snackbar to indicate successful download
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Image downloaded successfully.'),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Screenshot(
          controller: screenshotController,
          child: Text('This is a TextWidget. Hello from FF!'),
        ),
        ElevatedButton(
          onPressed: captureAndDownloadFromWidget,
          child: Text('Capture and Download'),
        ),
      ],
    );
  }
}
