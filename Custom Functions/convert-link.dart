// code created by https://www.youtube.com/@flutterflowexpert

String covertLink(String? link) {
  link = link ?? '';

  String decoded = Uri.decodeFull(link);
  decoded = decoded.replaceAll(' ', '%20');
  decoded = decoded.replaceAll('…', '%20');
  decoded = decoded.replaceAll('...', '%20');

  return decoded;
}