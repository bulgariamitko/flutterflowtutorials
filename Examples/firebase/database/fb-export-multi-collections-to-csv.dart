// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - no
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

// thanks to fabianCorrecha for this example

import 'dart:async';

Future<List<String>> getNombreVehiculo(
  List<DocumentReference> referencias,
) async {
  final nombres = <String>[];

  await Future.forEach(referencias, (reference) async {
    if (reference != null) {
      final snapshot = await reference.get();
      final data = snapshot.data() as Map<String, dynamic>;
      if (data != null && data.containsKey('nombre')) {
        final nombre = data['nombre'] as String;
        nombres.add(nombre);
      }
    }
  });

  return nombres;
}

Future downloadCollectionAsCSV(
  List<FormularioRecord>? formulario,
  List<DocumentReference>? carroReferences,
  List<DocumentReference>? motoReferences,
) async {
  formulario = formulario ?? [];
  carroReferences = carroReferences ?? [];
  motoReferences = motoReferences ?? [];

  String header = "Usuario Registrados";
  String fileContent =
      header +
      "\nNombre y Apellido, Numero de Cedula, Numero de Telefono, Correo, Cargo, Antiguedad, Carro, Moto";

  final carrosData = await getNombreVehiculo(carroReferences);
  String carros = carrosData.join(', ');

  final motosData = await getNombreVehiculo(motoReferences);
  String motos = motosData.join(', ');

  formulario.forEach((record) {
    String nombreApellido = record.nombreApellido as String? ?? "";
    String cedula = record.numeroCedula as String? ?? "";
    String telefono = record.numeroTelefono as String? ?? "";
    String correo = record.correoElectronico as String? ?? "";
    String cargo = record.cargo as String? ?? "";
    String antiguedad = record.antiguedad as String? ?? "";

    fileContent +=
        "\n$nombreApellido, $cedula, $telefono, $correo, $cargo, $antiguedad, $carros, $motos";
  });

  final fileName = "FF" + DateTime.now().toString() + ".csv";

  // Encode the string as a List<int> of UTF-8 bytes
  var bytes = utf8.encode(fileContent);

  final stream = Stream.fromIterable(bytes);
  return download(stream, fileName);
}
