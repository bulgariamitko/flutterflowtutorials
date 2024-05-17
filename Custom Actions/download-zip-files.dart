// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'package:http/http.dart' as http;
import 'package:download/download.dart';
import 'package:archive/archive.dart';

Future<void> downloadAndZipFiles(List<String> urls) async {
  // Create an empty archive
  final archive = Archive();

  // Download each file and add it to the archive
  for (var url in urls) {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Extract the filename from the URL
      final fileName = url.split('/').last;
      // Add the file to the archive
      archive.addFile(
          ArchiveFile(fileName, response.bodyBytes.length, response.bodyBytes));
    } else {
      // Handle failure or skip
      print('Failed to download file: $url');
    }
  }

  // Encode the archive to create a ZIP file
  final bytesList = ZipEncoder().encode(archive);

  final Uint8List bytes = Uint8List.fromList(bytesList ?? []);

  final Stream<int> byteStream =
      Stream.value(bytes).expand((element) => element);
  // Use the download package to trigger the file download
  // Permission is granted. Proceed with downloading and saving the file.
  download(byteStream, 'files.zip');
}
