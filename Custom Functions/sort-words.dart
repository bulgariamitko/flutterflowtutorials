// code created by https://www.youtube.com/@flutterflowexpert

List<String> sortWords(List<String>? words) {
  words = words ?? [];

  List<String> outputted = [];

  List<String> wordsArr = words;
  wordsArr.forEach((word) {
    word = word.replaceAll(' ', '');
    outputted.add(word);
  });

  // store words and counter in two lists
  List<String> wordsCount = [];
  List<int> wordsCountInt = [];
  for (var i = 0; i < outputted.length; i++) {
    if (wordsCount.contains(outputted[i])) {
      var elementIndex = wordsCount.indexOf(outputted[i]);
      wordsCountInt[elementIndex] = wordsCountInt[elementIndex] + 1;
    } else {
      wordsCount.add(outputted[i]);
      wordsCountInt.add(1);
    }
  }

  // combine the two lists
  List<dynamic> combined = [];
  // List<WordStruct> combinedd = [];
  List<int> allCounters = [];
  // find all unique words
  for (var i = 0; i < wordsCount.length; i++) {
    // final wordToAdd = WordStructBuilder();
    // wordToAdd.name = wordsCount[i];
    // wordToAdd.count = wordsCountInt[i];
    // wordToAdd.fontSize = 14;

    if (!allCounters.contains(wordsCountInt[i])) {
      allCounters.add(wordsCountInt[i]);
    }
  }

  // sort all words and there counters
  allCounters.sort((b, a) => a.compareTo(b));

  String first = '';
  String second = '';
  String third = '';
  String forth = '';
  String fifth = '';
  String sixth = '';
  String seven = '';
  for (var i = 0; i < wordsCount.length; i++) {
    if (allCounters[0] == wordsCountInt[i]) {
      first = wordsCount[i];
    } else if (allCounters[1] == wordsCountInt[i]) {
      second = wordsCount[i];
    } else if (allCounters[2] == wordsCountInt[i]) {
      third = wordsCount[i];
    } else if (allCounters[3] == wordsCountInt[i]) {
      forth = wordsCount[i];
    } else if (allCounters[4] == wordsCountInt[i]) {
      fifth = wordsCount[i];
    } else if (allCounters[5] == wordsCountInt[i]) {
      sixth = wordsCount[i];
    } else if (allCounters[6] == wordsCountInt[i]) {
      seven = wordsCount[i];
    }
  }

  // all words by sort
  List<String> sorted = [];
  sorted.add(first);
  sorted.add(second);
  sorted.add(third);
  sorted.add(forth);
  sorted.add(fifth);
  sorted.add(sixth);
  sorted.add(seven);

  return sorted;
}