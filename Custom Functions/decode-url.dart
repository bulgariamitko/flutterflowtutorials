// code created by https://www.youtube.com/@flutterflowexpert
// video - no
// support my work - https://github.com/sponsors/bulgariamitko

String decodeUrl(String? url) {
  url = url ?? '';

  String decoded = Uri.decodeFull(url);
  String withoutSpaces = decoded.replaceAll(' ', '-');

  return withoutSpaces;
}