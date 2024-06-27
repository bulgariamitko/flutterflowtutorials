// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'
    show consolidateHttpClientResponseBytes;

Future<void> finalVideoCreator(
  List<ClipStruct> videoUrls,
  String videoId,
  String userId,
) async {
  FFAppState().update(() {
    FFAppState().finalVideoIsProcessing = true;
    FFAppState().finalVideoStatus = 'Starting video processing...';
  });

  try {
    final tempDir = await getTemporaryDirectory();
    final List<String> intermediateVideos = [];

    // Download and process each video
    for (int i = 0; i < videoUrls.length; i++) {
      FFAppState().update(() {
        FFAppState().finalVideoStatus =
            'Processing video ${i + 1} of ${videoUrls.length}';
      });

      final videoPath = '${tempDir.path}/video_$i.mp4';
      await _downloadFile(videoUrls[i].url, videoPath);

      final intermediatePath = '${tempDir.path}/intermediate_$i.mp4';
      await _createIntermediateVideo(
          videoPath, intermediatePath, videoUrls[i].length);
      intermediateVideos.add(intermediatePath);
    }

    // Concatenate videos
    FFAppState().update(() {
      FFAppState().finalVideoStatus = 'Concatenating videos...';
    });

    final finalVideoPath = '${tempDir.path}/final_video.mp4';
    await _concatenateVideos(intermediateVideos, finalVideoPath);

    // Upload final video
    FFAppState().update(() {
      FFAppState().finalVideoStatus = 'Uploading final video...';
    });

    final finalVideoUrl = await _uploadVideo(finalVideoPath, userId, videoId);

    // Update Firestore
    await FirebaseFirestore.instance
        .collection('projects')
        .doc(videoId)
        .update({'finalVideo': finalVideoUrl});

    FFAppState().update(() {
      FFAppState().finalVideoStatus =
          'Video processing completed successfully!';
    });
  } catch (e) {
    FFAppState().update(() {
      FFAppState().finalVideoStatus = 'Error: ${e.toString()}';
    });
  } finally {
    FFAppState().update(() {
      FFAppState().finalVideoIsProcessing = false;
    });
  }
}

Future<void> _downloadFile(String url, String destPath) async {
  final response = await HttpClient().getUrl(Uri.parse(url));
  final HttpClientResponse httpResponse = await response.close();
  final bytes = await consolidateHttpClientResponseBytes(httpResponse);
  await File(destPath).writeAsBytes(bytes);
}

Future<void> _createIntermediateVideo(
    String inputPath, String outputPath, int lengthInSeconds) async {
  final command =
      '''-y -i "$inputPath" -t $lengthInSeconds -c:v h264 -c:a aac "$outputPath"''';
  print("Executing FFmpeg command: $command");

  final session = await FFmpegKit.execute(command);
  final returnCode = await session.getReturnCode();
  final log = await session.getLogs();

  log.forEach((log) {
    print(log.getMessage());
  });

  if (ReturnCode.isSuccess(returnCode)) {
    print("FFmpeg process completed successfully.");
    print("Return code: ${returnCode?.getValue()}");
    print("Duration: ${await session.getDuration()}");
  } else {
    final failStackTrace = await session.getFailStackTrace();
    print("FFmpeg process failed. Return code: ${returnCode?.getValue()}");
    print("Fail stack trace: $failStackTrace");
    throw Exception(
        "FFmpeg process failed with return code ${returnCode?.getValue()}");
  }
}

Future<void> _concatenateVideos(
    List<String> inputPaths, String outputPath) async {
  final tempDir = await getTemporaryDirectory();
  final inputFile = '${tempDir.path}/input.txt';
  await File(inputFile).writeAsString(
      inputPaths.map((p) => "file '${p.replaceAll("'", "\\'")}'").join('\n'));

  final command =
      '''-y -f concat -safe 0 -i "$inputFile" -c copy "$outputPath"''';
  print("Executing FFmpeg command: $command");

  final session = await FFmpegKit.execute(command);
  final returnCode = await session.getReturnCode();
  final log = await session.getLogs();

  log.forEach((log) {
    print(log.getMessage());
  });

  if (ReturnCode.isSuccess(returnCode)) {
    print("FFmpeg process completed successfully.");
    print("Return code: ${returnCode?.getValue()}");
    print("Duration: ${await session.getDuration()}");
  } else {
    final failStackTrace = await session.getFailStackTrace();
    print("FFmpeg process failed. Return code: ${returnCode?.getValue()}");
    print("Fail stack trace: $failStackTrace");
    throw Exception(
        "FFmpeg process failed with return code ${returnCode?.getValue()}");
  }
}

Future<void> checkFfmpegCapabilities() async {
  final encodersSession = await FFmpegKit.execute('-encoders');
  final encodersOutput = await encodersSession.getOutput();
  print("Available encoders:\n$encodersOutput");

  final formatsSession = await FFmpegKit.execute('-formats');
  final formatsOutput = await formatsSession.getOutput();
  print("Supported formats:\n$formatsOutput");
}

Future<String> _uploadVideo(
    String videoPath, String userId, String videoId) async {
  final fileName = 'users/$userId/uploads/final-video/$videoId/final-video.mp4';
  final ref = FirebaseStorage.instance.ref().child(fileName);
  final uploadTask = ref.putFile(File(videoPath));
  final snapshot = await uploadTask.whenComplete(() {});
  return await snapshot.ref.getDownloadURL();
}
