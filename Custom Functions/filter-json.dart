// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://youtube.com/watch?v=x-kivZ7ChD8
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

List<dynamic> filterJson(
  List<dynamic> data,
  String? field,
  String? operation,
  String? value,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  List<dynamic> filteredList = [];

  for (dynamic item in data) {
    List<String> fields = field!.split('.');
    dynamic itemValue = item;

    for (String f in fields) {
      itemValue = itemValue[f];
    }

    bool isMatch = false;

    switch (operation) {
      case '==':
        if (itemValue is String && value is String) {
          isMatch = itemValue.toLowerCase() == value.toLowerCase();
        } else {
          isMatch = itemValue == value;
        }
        break;
      case 'contains':
        if (itemValue is String && value is String) {
          isMatch = itemValue.toLowerCase().contains(value.toLowerCase());
        } else {
          throw ArgumentError(
              'Unsupported field type for "contains" operation');
        }
        break;
      default:
        throw ArgumentError('Unsupported operation');
    }

    if (isMatch) {
      filteredList.add(item);
    }
  }

  return filteredList;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}