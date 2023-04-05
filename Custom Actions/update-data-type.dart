// code created by https://www.youtube.com/@flutterflowexpert
// video - https://youtube.com/live/M7lfNCY3aB0
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

Future changeDataType(
  List<CarStruct>? car,
  DocumentReference? carRef,
) async {
  // Add your function code here!
  carRef = carRef ?? FirebaseFirestore.instance.doc('/cars/4343t34t3434r');

  CarStruct myCar = createCarStruct(
      onSale: true,
      brand: "Brand",
      color: Color.fromARGB(74, 15, 209, 129),
      doors: 4);

  final removeCar = {
    FieldValue.arrayRemove([myCar]),
  };

  CarStruct myNewCar = createCarStruct(
      onSale: true,
      brand: "New Car",
      color: Color.fromRGBO(45, 45, 45, 0.3),
      doors: 4);

  final addCar = {
    FieldValue.arrayUnion([myNewCar]),
  };

  await carRef.update({'name': "newName", 'car': removeCar});
  await carRef.update({'name': "newName", 'car': addCar});
}