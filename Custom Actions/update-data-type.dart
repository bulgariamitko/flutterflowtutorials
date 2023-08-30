// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=M7lfNCY3aB0
// widgets - Cg9Db2x1bW5fbjVoeXY1c3ISxAEKEkNvbnRhaW5lcl96cDlremhueRgBIgdyAHoA+gMAYo0BEjMKCWNhck9uU2FsZRImCgsKCWNhck9uU2FsZSIXCAYSD0NvbHVtbl9uNWh5djVzckICKgASQgoMY2FyUG5TYWxlUmVmEjIKDgoMY2FyUG5TYWxlUmVmIiAIBBIRU2NhZmZvbGRfdnNiNWE2ajNCAhIASgWCAQIQASoSQ29udGFpbmVyXzVwMDZieXdhsgESQ29udGFpbmVyXzVwMDZieXdhGAQiCiIA+gMA8gQCCgBqLwoFCgNjYXISJggEEhFTY2FmZm9sZF92c2I1YTZqM0ICEgBKC4IBCAoGCgRjYXJz
// replace - [{"Name of Data Type": "Car"}]
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

Future changeDataType(
  List<CarStruct>? car,
  DocumentReference? carRef,
) async {
  // Add your function code here!
  carRef = carRef ?? FirebaseFirestore.instance.doc('/cars/4343t34t3434r');

  CarStruct myCar = CarStruct(
      onSale: true,
      brand: "Brand",
      color: Color.fromARGB(74, 15, 209, 129),
      doors: 4);

  final removeCar = {
    FieldValue.arrayRemove([myCar]),
  };

  CarStruct myNewCar = CarStruct(
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