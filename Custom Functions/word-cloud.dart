// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

List<dynamic> wordCloud(String? words) {
  words = words ?? '';

  List<String> outputted = [];

  List<String> wordsArr = words.split(',');
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

  var first = {};
  var second = {};
  var third = {};
  var forth = {};
  var fifth = {};
  var sixth = {};
  var seven = {};
  // sizes (total 8) - 32, 48, 62, 78, 96, 100, 118, 136
  // colors (total 5) - #1b6d9b, #003a69, #003d66, #2b9bcc, #002340
  String mainColor = "#002340";
  // List<String> colors = ["#00447C", "#005AA3", "#0079DD", "#1897FF", "#78C2FF"];
  for (var i = 0; i < wordsCount.length; i++) {
    int fontSize = 24;
    if (allCounters[0] == wordsCountInt[i]) {
      first = {
        "word": wordsCount[i].toUpperCase(),
        "count": wordsCountInt[i],
        "color": mainColor,
        "font": 136
      };
    } else if (allCounters[1] == wordsCountInt[i]) {
      second = {
        "word": wordsCount[i].toUpperCase(),
        "count": wordsCountInt[i],
        "color": mainColor,
        "font": 118
      };
    } else if (allCounters[2] == wordsCountInt[i]) {
      third = {
        "word": wordsCount[i].toUpperCase(),
        "count": wordsCountInt[i],
        "color": mainColor,
        "font": 100
      };
    } else if (allCounters[3] == wordsCountInt[i]) {
      forth = {
        "word": wordsCount[i].toUpperCase(),
        "count": wordsCountInt[i],
        "color": mainColor,
        "font": 96
      };
    } else if (allCounters[4] == wordsCountInt[i]) {
      fifth = {
        "word": wordsCount[i].toUpperCase(),
        "count": wordsCountInt[i],
        "color": mainColor,
        "font": 78
      };
    } else if (allCounters[5] == wordsCountInt[i]) {
      sixth = {
        "word": wordsCount[i].toUpperCase(),
        "count": wordsCountInt[i],
        "color": mainColor,
        "font": 62
      };
    } else if (allCounters[6] == wordsCountInt[i]) {
      seven = {
        "word": wordsCount[i].toUpperCase(),
        "count": wordsCountInt[i],
        "color": mainColor,
        "font": 48
      };
    }
  }

  // min every 5 word to be a big word
  // repreat words in list = 0 - 2, 1 - 2, 2 - 3, 3 - 3, 4 - 3, 5 - 4, 6 - 5
  var bigWords = [
    first,
    first,
    second,
    second,
    third,
    third,
    third,
    third,
    forth,
    forth,
    forth,
    fifth,
    fifth,
    fifth,
    sixth,
    sixth,
    sixth,
    sixth,
    seven,
    seven,
    seven,
    seven,
    seven
  ];
  int repreatingWordsCounter = 1;
  int midList = (wordsCount.length / 2).round();
  // put big word every 2 to 5 words
  // int randomPosition = 2 + math.Random().nextInt(5 - 2);
  int randomPosition = 5;
  for (var i = 0; i < wordsCount.length; i++) {
    // sizes (total 7) - 24, 32, 48, 62, 96, 136
    if (midList == i) {
      combined.add(first);
      repreatingWordsCounter = 1;
    } else if (midList - 1 == i) {
      combined.add(second);
      repreatingWordsCounter = 1;
    } else if (midList + 1 == i) {
      combined.add(third);
      repreatingWordsCounter = 1;
    } else if (midList + 2 == i) {
      combined.add(forth);
      repreatingWordsCounter = 1;
    } else if (midList - 2 == i) {
      combined.add(fifth);
      repreatingWordsCounter = 1;
    } else {
      combined.add({
        "word": wordsCount[i].toUpperCase(),
        "count": wordsCountInt[i],
        "color": mainColor,
        "font": 32
      });
    }

    print([repreatingWordsCounter, randomPosition]);

    // add random big word if no big word in the last 5 words
    if (repreatingWordsCounter >= randomPosition) {
      final random = math.Random();
      int index = random.nextInt(bigWords.length);
      var element = bigWords[index];
      // remove the item from the array after it was added
      bigWords.removeAt(index);

      combined.add(element);

      // default to new random number and reset counter
      randomPosition = math.Random().nextInt(5) + 1;
      repreatingWordsCounter = 0;
    }

    repreatingWordsCounter++;
  }

  return combined;
}
