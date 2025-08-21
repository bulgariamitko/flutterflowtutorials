// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - no
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

// this is a custom function

List<PropertyRecord> sortListings(List<PropertyRecord>? data, String? sortBy) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  //null safety
  data ??= [];
  sortBy ??= 'date';

  // Sort the filtered data
  if (sortBy == 'date') {
    data.sort(
      (a, b) => a.createdTime!.compareTo(b.createdTime ?? DateTime.now()),
    );
  } else if (sortBy == 'status') {
    data.sort((a, b) => a.status.compareTo(b.status));
  } else if (sortBy == 'price') {
    data.sort((a, b) => a.price.compareTo(b.price));
  }

  return data;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
