// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

Future<dynamic> prepareAnOrder() async {
  List<dynamic> services = [];

  FFAppState().totalBags = '0';
  FFAppState().totalItems = '0';
  if (FFAppState().wdfbool) {
    dynamic service = {
      "id": "1",
      "bagCount": FFAppState().wdf,
      "itemCount": 0,
      "name": "Dry Cleaning"
    };

    FFAppState().totalBags =
        (int.parse(FFAppState().totalBags) + int.parse(FFAppState().wdf))
            .toString();
    services.add(service);
  }

  if (FFAppState().wdibool) {
    dynamic service = {
      "id": "2",
      "bagCount": FFAppState().wdi,
      "itemCount": 0,
      "name": "Wash and Fold"
    };
    FFAppState().totalBags =
        (int.parse(FFAppState().totalBags) + int.parse(FFAppState().wdi))
            .toString();
    services.add(service);
  }

  if (FFAppState().dcbool) {
    dynamic service = {
      "id": "3",
      "bagCount": 0,
      "itemCount": FFAppState().dc,
      "name": "Wash and Iron"
    };
    FFAppState().totalItems =
        (int.parse(FFAppState().totalItems) + int.parse(FFAppState().dc))
            .toString();

    services.add(service);
  }

  if (FFAppState().rabool) {
    dynamic service = {
      "id": "4",
      "bagCount": 0,
      "itemCount": FFAppState().ra,
      "name": "R A"
    };
    FFAppState().totalItems =
        (int.parse(FFAppState().totalItems) + int.parse(FFAppState().ra))
            .toString();

    services.add(service);
  }

  return services;
}
