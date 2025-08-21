// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - no
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

Future<void> sendEmail(
  String recipientEmail,
  String subject,
  String body,
  FFUploadedFile attachment,
) async {
  final smtpServer = gmail('name@gmail.com', 'myPassword');

  // Create a temporary file from the FFUploadedFile
  final tempDir = await getTemporaryDirectory();
  final tempFile = File(path.join(tempDir.path, attachment.name));
  await tempFile.writeAsBytes(attachment.bytes!);

  final message = Message()
    ..from = Address('name@gmail.com', 'Your Name')
    ..recipients.add(recipientEmail)
    ..subject = subject
    ..text = body
    ..attachments = [
      FileAttachment(tempFile)
        ..fileName = attachment.name
        ..contentType = attachment.contentType,
    ];

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent. \n${e.toString()}');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  } finally {
    // Clean up the temporary file
    if (await tempFile.exists()) {
      await tempFile.delete();
    }
  }
}
