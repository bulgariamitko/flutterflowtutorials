// code created by https://www.youtube.com/@flutterflowexpert

String increaseNum(String? input) {
  input = input ?? '';
  String output = (int.parse(input) + 1).toString();

  return output;
}