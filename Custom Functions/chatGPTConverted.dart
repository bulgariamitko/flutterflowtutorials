// code created by https://www.youtube.com/@flutterflowexpert
// video - https://youtube.com/watch?v=kcqrHDqpmoo
// support my work - https://github.com/sponsors/bulgariamitko

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