// code created by https://www.youtube.com/@flutterflowexpert
// video - no
// support my work - https://github.com/sponsors/bulgariamitko

String covertLink(String? link) {
  link = link ?? '';

  String decoded = Uri.decodeFull(link);
  decoded = decoded.replaceAll(' ', '%20');
  decoded = decoded.replaceAll('…', '%20');
  decoded = decoded.replaceAll('...', '%20');

  return decoded;
}