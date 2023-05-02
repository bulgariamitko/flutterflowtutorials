// code created by https://www.youtube.com/@flutterflowexpert
// video - no
// support my work - https://github.com/sponsors/bulgariamitko

List<String>? updateValueInList(
  List<String>? list,
  int? index,
  String? newValue,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // null safety
  list ??= [];
  index ??= 0;
  newValue ??= 'myNewValue';

  if (index >= 0 && index < list.length) {
    List<String> newList = List.from(list);
    newList[index] = newValue;
    return newList;
  } else {
    print('Index out of range');
    return list;
  }

  /// MODIFY CODE ONLY ABOVE THIS LINE
}