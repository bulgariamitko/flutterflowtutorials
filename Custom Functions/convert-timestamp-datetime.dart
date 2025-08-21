// YouTube channel - https://www.youtube.com/@dimitarklaturov
// paid video - https://www.youtube.com/watch?v=idXHYU0co5Y
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

DateTime convertTimestampIntoDateTime(String timestampDate) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // Parse the timestamp string as milliseconds since epoch
  int timestamp = int.parse(timestampDate);

  // Convert milliseconds to DateTime object
  return DateTime.fromMillisecondsSinceEpoch(timestamp);

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
