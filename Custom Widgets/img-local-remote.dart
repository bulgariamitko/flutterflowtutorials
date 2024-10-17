// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=LfAwHZndeWQ
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class DisplayImg extends StatefulWidget {
  const DisplayImg({
    super.key,
    this.width,
    this.height,
    required this.path,
  });

  final double? width;
  final double? height;
  final String path;

  @override
  State<DisplayImg> createState() => _DisplayImgState();
}

class _DisplayImgState extends State<DisplayImg> {
  final ImageProvider defaultImage = NetworkImage(
    'https://images.pexels.com/photos/1037996/pexels-photo-1037996.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  );

  @override
  Widget build(BuildContext context) {
    final bool isNetworkUrl =
        widget.path.startsWith('http') || widget.path.startsWith('https');
    ImageProvider imageProvider;

    if (isNetworkUrl) {
      imageProvider = NetworkImage(widget.path);
    } else {
      final file = File(widget.path);
      if (file.existsSync()) {
        imageProvider = FileImage(file);
      } else {
        imageProvider = defaultImage;
      }
    }

    return Image(
      image: imageProvider,
      width: widget.width,
      height: widget.height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image(
          image: defaultImage,
          width: widget.width,
          height: widget.height,
          fit: BoxFit.cover,
        );
      },
    );
  }
}
