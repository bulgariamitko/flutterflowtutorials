// code created by https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=rrgw84My5tw
// support my work - https://github.com/sponsors/bulgariamitko

Future addToNum() async {
  FFAppState().update(() {
    FFAppState().number = FFAppState().number + 1;
  });
}