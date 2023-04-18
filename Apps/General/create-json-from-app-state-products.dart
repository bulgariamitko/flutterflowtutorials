// code created by https://www.youtube.com/@flutterflowexpert
// video - no
// support my work - https://github.com/sponsors/bulgariamitko

Future<dynamic> prepareAnOrder() async {
  List<dynamic> products = [];

  FFAppState().totalBags = '0';
  FFAppState().totalItems = '0';
  if (FFAppState().wdfbool) {
    dynamic product = {
      "id": "10",
      "price": "45",
      "pieces": FFAppState().wdf,
      "quantity": FFAppState().wdf,
      "name": "Product Name"
    };

    FFAppState().totalBags =
        (int.parse(FFAppState().totalBags) + int.parse(FFAppState().wdf))
            .toString();
    products.add(product);
  }

  if (FFAppState().wdibool) {
    dynamic product = {
      "id": "10",
      "price": "45",
      "pieces": FFAppState().wdi,
      "quantity": FFAppState().wdi,
      "name": "Product Name"
    };
    FFAppState().totalBags =
        (int.parse(FFAppState().totalBags) + int.parse(FFAppState().wdi))
            .toString();
    products.add(product);
  }

  if (FFAppState().dcbool) {
    dynamic product = {
      "id": "10",
      "price": "45",
      "pieces": FFAppState().dc,
      "quantity": FFAppState().dc,
      "name": "Dry Cleaning"
    };
    FFAppState().totalItems =
        (int.parse(FFAppState().totalItems) + int.parse(FFAppState().dc))
            .toString();

    products.add(product);
  }

  if (FFAppState().rabool) {
    dynamic product = {
      "id": "10",
      "price": "45",
      "pieces": FFAppState().ra,
      "quantity": FFAppState().ra,
      "name": "Product Name"
    };
    FFAppState().totalItems =
        (int.parse(FFAppState().totalItems) + int.parse(FFAppState().ra))
            .toString();

    products.add(product);
  }

  return products;
}