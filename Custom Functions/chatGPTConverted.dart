// code created by https://www.youtube.com/@flutterflowexpert
// video - https://youtu.be/kcqrHDqpmoo
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

dynamic chatGPTConverter(String? message) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // null safety
  message ??= '';

  List<dynamic> result = [];

  // add the role
  result.add({"role": "user", "content": message});
  print(result);
  return result;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}