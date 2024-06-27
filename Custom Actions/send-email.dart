// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future sendEmail(
  String recipientEmail,
  String subject,
  String body,
) async {
  final smtpServer = gmail('randy@smart-manifest.com', 'htttkkztxbfvyazj');

  final message = Message()
    ..from = Address('randy@smart-manifest.com', 'Your Name')
    ..recipients.add(recipientEmail)
    ..subject = subject
    ..text = body;

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent. \n${e.toString()}');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}
