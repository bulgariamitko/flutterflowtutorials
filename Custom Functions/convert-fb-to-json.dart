// code created by https://www.youtube.com/@flutterflowexpert
// video -
// widgets - Cg9Db2x1bW5feDR3ZDdsM28SkQIKEUxpc3RWaWV3XzhsbHRmcGltEtIBCgxSb3dfdGh6Z2dpdDASWwoNVGV4dF9ieG1zMXhjMhgCIkYSEgoLSGVsbG8gV29ybGRABqgBAJoBLAoCAgEqJggGEhFMaXN0Vmlld184bGx0ZnBpbUICKgBKCyIJCgckLmJyYW5k+gMAYgASWgoNVGV4dF8xcXkwMnlvdhgCIkUSEgoLSGVsbG8gV29ybGRABqgBAJoBKwoCAgEqJQgGEhFMaXN0Vmlld184bGx0ZnBpbUICKgBKCiIICgYkLm5hbWX6AwBiABgDIgcaAhAD+gMAGAYiCUIECAEQAvoDAGoaCgUKA2NhchIRCAxCDSILCgcKBWpzb25zEAEYBCIFIgD6AwA=
// replace - [{"Collection name": "Cars"}, {"Field name 1": "name"}, {"Field name 2": "brand"}]
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

List<dynamic> convertFBtoJSON(List<CarsRecord>? carsDocs) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // null safety
  carsDocs ??= [];

  List<Map<String, dynamic>> carsJson = carsDocs.map((car) {
    return {
      'name': car.name,
      'brand': car.brand,
    };
  }).toList();

  return carsJson;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}