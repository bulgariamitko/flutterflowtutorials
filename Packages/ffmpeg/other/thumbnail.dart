// YouTube channel - https://www.youtube.com/@dimitarklaturov
// paid video - https://www.youtube.com/watch?v=LfAwHZndeWQ
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path/path.dart' as p;
import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../../backend/firebase_storage/storage.dart';

final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

Future<String> generateAndUploadThumbnail(
  String videoPath,
  String videoId,
) async {
  final thumbnailPath = await _generateThumbnail(videoPath);
  if (thumbnailPath.isNotEmpty) {
    final downloadUrl = await _uploadThumbnailToFirebase(
      thumbnailPath,
      videoId,
    );
    return downloadUrl ?? '';
  } else {
    return '';
  }
}

Future<String> _generateThumbnail(String videoPath) async {
  final directory = await getTemporaryDirectory();
  final thumbnailPath = p.join(directory.path, 'thumbnail.jpg');

  // Ensure the directory exists
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }

  print('Thumbnail path: $thumbnailPath');

  final arguments = [
    '-y', // Add this option to overwrite the output file if it exists
    '-i', videoPath,
    '-ss', '00:00:02', // Take a screenshot at 5 seconds
    '-vframes', '1',
    thumbnailPath,
  ];

  final int result = await _flutterFFmpeg.executeWithArguments(arguments);

  if (result == 0) {
    print('Thumbnail created at $thumbnailPath');
    return thumbnailPath;
  } else {
    print('Failed to generate thumbnail');
    return '';
  }
}

Future<String?> _uploadThumbnailToFirebase(
  String filePath,
  String videoId,
) async {
  final file = File(filePath);
  if (!await file.exists()) {
    print('Thumbnail file does not exist: $filePath');
    return null;
  }

  final bytes = await file.readAsBytes();

  final now = DateTime.now();
  final formattedDateTime =
      '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}-${now.second.toString().padLeft(2, '0')}';
  final fileExtension = p.extension(filePath);
  final fileName = '$formattedDateTime$fileExtension';

  final directoryPath = 'projects/$videoId/thumbnails';
  final storagePath = '$directoryPath/$fileName';

  final downloadUrl = await uploadData(storagePath, bytes);

  return downloadUrl;
}
