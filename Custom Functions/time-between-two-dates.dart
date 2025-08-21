// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - no
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'package:intl/intl.dart';

String timeDifference(String date1, String date2) {
  // Date format used for parsing input date strings
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  // Parse input date strings into DateTime objects
  DateTime dateTime1 = dateFormat.parse(date1);
  DateTime dateTime2 = dateFormat.parse(date2);

  // Calculate the duration between two dates
  Duration duration = dateTime1.difference(dateTime2).abs();

  // Calculate the components of the duration
  int years = duration.inDays ~/ 365;
  int months = (duration.inDays % 365) ~/ 30;
  int days = (duration.inDays % 365) % 30;
  int hours = duration.inHours % 24;
  int minutes = duration.inMinutes % 60;

  // Format the duration into a string
  String result =
      '$years years, $months months, $days days, $hours hours, $minutes minutes';

  return result;
}
