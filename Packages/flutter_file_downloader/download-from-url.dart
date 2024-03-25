// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

// Add - "MANAGE_EXTERNAL_STORAGE" Permission in order to download the file in "Downloads" folder

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:archive/archive.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

Future downloadAndZipMp3sv2(
  List<String> urls,
  Future Function() callbackAction,
) async {
  //Or download multiple files
  final List<File?> result = await FileDownloader.downloadFiles(
      urls: urls,
      isParallel:
          true, //if this is set to true, your download list will request to be downloaded all at once
      //if your downloading queue fits them all, they all will start downloading
      //if it's set to false, it will download every file individually
      //default is true
      onAllDownloaded: () {
        callbackAction.call();
        //This callback will be fired when all files are downloaded
      });
  //This method will return a list of File? in the same order as the urls,
  //so if the url[2] failed to download,
  //then result[2] will be null

  //You can enable or disable the log, this will help you track your download batches
  FileDownloader.setLogEnabled(true);
  //default is false

  //You can set the number of consecutive downloads to help you preserving device's resources
  FileDownloader.setMaximumParallelDownloads(25);
  //This method will allow the plugin to download 10 files at a time
  //if you requested to download more than that, it will wait until a download is done to start another
  //default is 25, maximum is 25, minimum is 1
}
