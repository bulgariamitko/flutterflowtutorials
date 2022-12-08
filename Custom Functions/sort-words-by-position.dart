// code created by https://www.youtube.com/@flutterflowexpert

import 'dart:math' as math;

String sortWordsByPosition(List<String>? words) {
  words = words ?? [];

  List<String> outputted = [];

  List<String> wordsArr = words;
  wordsArr.forEach((word) {
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
  List<int> allCounters = [];
  // find all unique words
  for (var i = 0; i < wordsCount.length; i++) {
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
    }
  }

  // all words by sort
  String sorted = '$first-$second-$third-$forth-$fifth';

  sorted = sorted.replaceAll("като съм със семейството си", "1");
  sorted = sorted.replaceAll("ще сбъдна мечта", "2");
  sorted = sorted.replaceAll("ще се обадя на баба и дядо", "3");
  sorted = sorted.replaceAll("като правя повече добри дела", "4");
  sorted = sorted.replaceAll("ще изненадам приятелите си", "5");

  // Split the input string into a list of strings
  List<String> numbers = sorted.split("-");

  String path =
      'https://raw.githubusercontent.com/bulgariamitko/flutterflowtutorials/main/1-2-3-4-5.json';
  // Check if the third number is 1
  if (numbers[0] == "1") {
    path =
        'https://raw.githubusercontent.com/bulgariamitko/flutterflowtutorials/main/1-2-3-4-5.json';
  }
  if (numbers[0] == "2") {
    path =
        'https://raw.githubusercontent.com/bulgariamitko/flutterflowtutorials/main/2-1-3-4-5.json';
  }
  if (numbers[0] == "3") {
    path =
        'https://raw.githubusercontent.com/bulgariamitko/flutterflowtutorials/main/2-3-1-4-5.json';
  }
  if (numbers[0] == "4") {
    path =
        'https://raw.githubusercontent.com/bulgariamitko/flutterflowtutorials/main/2-3-4-1-5.json';
  }
  if (numbers[0] == "5") {
    path =
        'https://raw.githubusercontent.com/bulgariamitko/flutterflowtutorials/main/2-3-4-5-1.json';
  }

  // Join the list of numbers back into a string and return it
  return path;

  // return '$sorted.json';
}