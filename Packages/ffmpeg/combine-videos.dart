// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=LfAwHZndeWQ
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:path/path.dart' as path;
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class FileHandler {
  static Future<String> getAppDirectory() async {
    if (Platform.isIOS) {
      return (await getApplicationDocumentsDirectory()).path;
    } else if (Platform.isAndroid) {
      return (await getExternalStorageDirectory() ??
              await getApplicationDocumentsDirectory())
          .path;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static Future<String> getFilePath(String fileName) async {
    final appDir = await getAppDirectory();
    return path.join(appDir, fileName);
  }

  static String getFileNameFromPath(String fullPath) {
    return path.basename(fullPath);
  }

  static Future<String> getFullPath(String fileName) async {
    return await getFilePath(fileName);
  }
}

Future<String> generateThumbnail(String videoPath) async {
  try {
    final thumbnailFileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final thumbnailPath = await FileHandler.getFilePath(thumbnailFileName);

    // Calculate the middle of the video duration
    final videoPlayerController = VideoPlayerController.file(File(videoPath));
    await videoPlayerController.initialize();
    final videoDuration = videoPlayerController.value.duration;
    final middlePosition = videoDuration.inMilliseconds ~/ 2;
    await videoPlayerController.dispose();

    final thumbnail = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: thumbnailPath,
      imageFormat: ImageFormat.PNG,
      maxHeight: 640,
      maxWidth: 480,
      quality: 100,
      timeMs: middlePosition,
    );

    return thumbnail != null ? FileHandler.getFileNameFromPath(thumbnail) : '';
  } catch (e) {
    print('Error generating thumbnail: $e');
    return '';
  }
}

Future<List<String>> combineVideos(
  String video1Url,
  String video2Url,
) async {
  try {
    print("Starting combineVideos function");

    // Download videos if they are URLs
    final video1Path = await _downloadVideoIfNeeded(video1Url);
    final video2Path = await _downloadVideoIfNeeded(video2Url);

    // Prepare output file
    final String outputFileName =
        'combined_${DateTime.now().millisecondsSinceEpoch}.mp4';
    final String outputPath = await FileHandler.getFilePath(outputFileName);

    // Create input list file
    final String inputListPath =
        await FileHandler.getFilePath('input_list.txt');
    final File inputListFile = File(inputListPath);
    await inputListFile.writeAsString("file '$video1Path'\nfile '$video2Path'");

    // FFmpeg command to combine videos
    String command = '-y -f concat -safe 0 -i "$inputListPath" '
        '-c:v libx264 -preset slow -crf 22 '
        '-c:a aac -b:a 192k -ar 44100 '
        '-vsync 1 -max_muxing_queue_size 1024 '
        '-fflags +genpts '
        '"$outputPath"';

    print("Executing FFmpeg command: $command");
    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      print("Video combination complete. Output file: $outputFileName");

      // Generate thumbnail
      final thumbnailFileName = await generateThumbnail(outputPath);

      // Clean up temporary files
      await inputListFile.delete();

      return [outputFileName, thumbnailFileName];
    } else {
      print("Failed to combine videos. Return code: $returnCode");
      final logs = await session.getLogsAsString();
      print("FFmpeg logs: $logs");
      throw Exception('Failed to combine videos');
    }
  } catch (e) {
    print("Error in combineVideos: $e");
    throw Exception('Failed to combine videos: $e');
  }
}

Future<String> _downloadVideoIfNeeded(String videoUrl) async {
  if (videoUrl.startsWith('http://') || videoUrl.startsWith('https://')) {
    // Download the video
    final response = await http.get(Uri.parse(videoUrl));
    final bytes = response.bodyBytes;
    final String fileName =
        'downloaded_${DateTime.now().millisecondsSinceEpoch}.mp4';
    final String filePath = await FileHandler.getFilePath(fileName);
    final File file = File(filePath);
    await file.writeAsBytes(bytes);
    return filePath;
  } else {
    // It's already a local path
    return videoUrl;
  }
}
