// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=sauJPpZZ1G0
// replace - [{"Collection name": "Cars"}, {"Field name 1": "name"}, {"Field name 2": "brand"}]
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

List<CarsRecord> convertJSONToDoc(List<dynamic>? jsonList) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  jsonList ??= [];
  return jsonList.map((json) {
    final data = createCarsRecordData(
      name: json['name'] as String?,
      brand: json['brand'] as String?,
      doors: json['doors'] as int?,
    );

    // Assuming you have a way to get a DocumentReference for a new document
    final docRef = FirebaseFirestore.instance.collection('cars').doc();

    // Create a new CarsRecord with the data and reference
    return CarsRecord.getDocumentFromData(data, docRef);
  }).toList();

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
