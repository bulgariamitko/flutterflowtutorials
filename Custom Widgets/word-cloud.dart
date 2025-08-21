// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - https://www.youtube.com/watch?v=IwhSbx1yN1M
// widgets - Cg9Db2x1bW5feDUweThqaWcSmgIKEkNvbnRhaW5lcl9ybW93OG12aRLYAQoSQ29udGFpbmVyX29hcnpqejB0GAEiHHISCQAAAAAAAAAAEQAAAAAAAAAA+gMA8gQCCgBilgESNgoKZGltZW5zaW9ucxIoCgwKCmRpbWVuc2lvbnMyGCIWCgkRAAAAAAAAWUASCREAAAAAAABZQBJVCgV3b3JkcxJMCgcKBXdvcmRzIkEIBBIRU2NhZmZvbGRfaWNmeWp1N2ZCAhIASiZ6JAoiCA1CEXoPCg0QBxoHCgV3b3JkcyABSguCAQgKBgoEd29yZBoFV29yZHOCAQVXb3Jkc5gBARgBIiUKIAoWCgkRAAAAAAAAWUASCREAAAAAAABZQBIEWgBiACIA+gMAYgAYBCIOIgQIABgF+gMA8gQCCgA=
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'dart:ui' as ui;
import 'package:flutter_scatter/flutter_scatter.dart';

class Words extends StatefulWidget {
  const Words({Key? key, this.width, this.height, this.words})
    : super(key: key);

  final double? width;
  final double? height;
  final List<String>? words;

  @override
  _WordsState createState() => _WordsState();
}

class _WordsState extends State<Words> {
  Widget _words = const Center();

  @override
  void initState() {
    List<String> words = widget.words ?? [];
    _words = WordCloudExample(words);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) => _words);
  }
}

class SimpleScaffold extends StatelessWidget {
  const SimpleScaffold({Key? key, this.title, this.child}) : super(key: key);

  final String? title;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title!)),
      body: child,
    );
  }
}

class FlutterHashtag {
  const FlutterHashtag(this.hashtag, this.color, this.size, this.rotated);
  final String hashtag;
  final Color color;
  final int size;
  final bool rotated;
}

class FlutterColors {
  const FlutterColors._();

  static const Color bluedark = Color(0xFF002340);
  static const Color blueverylight = Color(0xFF2b9bcc);
  static const Color bluelight = Color(0xFF1b6d9b);
  static const Color blue = Color(0xFF003d66);
  static const Color white = Color(0xFFffffff);
  static const Color grey = Color(0xFFc4dfe9);
}

class WordCloudExample extends StatefulWidget {
  const WordCloudExample(this.wordsToC);

  final List<String> wordsToC;

  @override
  State<WordCloudExample> createState() => _WordCloudExampleState();
}

class _WordCloudExampleState extends State<WordCloudExample> {
  List<FlutterHashtag> kFlutterHashtags = <FlutterHashtag>[
    // const FlutterHashtag('#FlutterLive', FlutterColors.bluedark, 10, false),
  ];

  @override
  Widget build(BuildContext context) {
    Map map = {};
    List<Widget> widgets = <Widget>[];

    widget.wordsToC.forEach(
      (x) => map[x.toLowerCase()] = !map.containsKey(x.toLowerCase())
          ? (1)
          : (map[x.toLowerCase()] + 1),
    );

    map.forEach((k, v) {
      FlutterHashtag item = FlutterHashtag(
        k,
        FlutterColors.blue,
        v * 15,
        false,
      );
      kFlutterHashtags.add(item);
    });

    map.clear();
    widgets.clear();

    print([map, widgets]);

    for (var i = 0; i < kFlutterHashtags.length; i++) {
      widgets.add(ScatterItem(kFlutterHashtags[i], i));
    }

    final screenSize = MediaQuery.of(context).size;
    final ratio = screenSize.width / screenSize.height;

    return Center(
      child: FittedBox(
        child: Scatter(
          fillGaps: true,
          delegate: ArchimedeanSpiralScatterDelegate(ratio: ratio),
          children: widgets,
        ),
      ),
    );
  }
}

class ScatterItem extends StatelessWidget {
  const ScatterItem(this.hashtag, this.index);
  final FlutterHashtag hashtag;
  final int index;

  @override
  Widget build(BuildContext context) {
    final TextStyle? style = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontSize: hashtag.size.toDouble(),
      color: hashtag.color,
    );

    return RotatedBox(
      quarterTurns: hashtag.rotated ? 1 : 0,
      child: Text(hashtag.hashtag, style: style),
    );
  }
}
