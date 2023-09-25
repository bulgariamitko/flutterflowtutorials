// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

double? averageReviewRating(List<ReviewsRecord>? reviews) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // get the average review rating from the list of Reviews of the coachModel
  if (reviews == null || reviews.isEmpty) {
    return null;
  }
  double sum = 0.0;
  for (ReviewsRecord review in reviews) {
    sum += (review.rating?.toDouble() ?? 0.0);
  }
  return sum / reviews.length;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}