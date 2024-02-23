// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=ltGd6Y6v56E
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'dart:convert';

import '../../backend/api_requests/api_calls.dart';

class ImgFromBytes extends StatefulWidget {
  const ImgFromBytes({
    Key? key,
    this.width,
    this.height,
    this.link,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? link;

  @override
  _ImgFromBytesState createState() => _ImgFromBytesState();
}

class _ImgFromBytesState extends State<ImgFromBytes> {
  Future<Uint8List> _loadImageBytes() async {
    final response = await DownloadFileCall.call(
      url: widget.link ?? '',
    );

    return response.response!.bodyBytes;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _loadImageBytes(),
      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Return a circular progress indicator while waiting
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Image.memory(snapshot.data!);
        }
      },
    );
  }
}
