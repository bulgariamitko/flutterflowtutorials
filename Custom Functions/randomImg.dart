// code created by https://www.youtube.com/@flutterflowexpert
// video - https://youtube.com/watch?v=f3enSdgZ6oU

String? randomInt() {
  /// MODIFY CODE ONLY BELOW THIS LINE

  final random = math.Random();
  int randomInt = random.nextInt(999) + 1;
  String randomImg = "https://picsum.photos/seed/$randomInt/600";

  return randomImg;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}