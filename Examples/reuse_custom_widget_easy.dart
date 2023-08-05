// code created by https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=rrgw84My5tw
// support my work - https://github.com/sponsors/bulgariamitko

import '../actions/add_to_num.dart';

class CustomCounterWidget extends StatefulWidget {
  const CustomCounterWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _CustomCounterWidgetState createState() => _CustomCounterWidgetState();
}

class _CustomCounterWidgetState extends State<CustomCounterWidget> {
  void incrementCounter() {
    addToNum();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Counter Value:',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          FFAppState().number.toString(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}