// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=HtvtwLmaI0w
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

import 'dart:math';

Future<CarsRecord> getRandomDoc(List<DocumentReference> docRefs) async {
  int randomIndex = Random().nextInt(docRefs.length);
  CarsRecord randomDoc = await CarsRecord.getDocumentOnce(docRefs[randomIndex]);

  return randomDoc;
}
