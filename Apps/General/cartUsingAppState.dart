// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

Future calTotal(
  String? productid,
  bool? plus,
  String? name,
  String? price,
) async {
  // null safety
  productid ??= '0';
  plus ??= true;
  name ??= 'name';
  price ??= '0';

  bool addItemInList = true;
  FFAppState().Total = 0;
  for (int i = 0; i < FFAppState().prices.length; i++) {
    // if the product is already in the list
    if (FFAppState().productsids[i] == productid) {
      print(['exist', productid, FFAppState().productsids[i], name, price]);
      if (plus) {
        print('+');
        FFAppState().qttys[i] =
            (int.parse(FFAppState().qttys[i]) + 1).toString();

        addItemInList = false;
        break;
      } else {
        int newQuantity = int.parse(FFAppState().qttys[i]) - 1;

        FFAppState().qttys[i] =
            (int.parse(FFAppState().qttys[i]) - 1).toString();
        // remove the item if qtty is 0
        if (newQuantity <= 0) {
          print('remove');
          FFAppState().productName.removeAt(i);
          FFAppState().prices.removeAt(i);
          FFAppState().qttys.removeAt(i);
          FFAppState().productsids.removeAt(i);

          addItemInList = false;
          break;
        } else {
          print('-');
          FFAppState().qttys[i] = newQuantity.toString();

          addItemInList = false;
          break;
        }
      }
    }
  }

  // add a new product in cart
  if ((FFAppState().prices.length == 0 || addItemInList) && plus != false) {
    print('add a new item');
    FFAppState().prices.add(price);
    FFAppState().qttys.add('1');
    FFAppState().productName.add(name);
    FFAppState().procudtTotal.add(price);
    FFAppState().productsids.add(productid);

    // cal product total
    FFAppState().procudtTotal[0] = (double.parse(FFAppState().prices[0]) *
            int.parse(FFAppState().qttys[0]))
        .toString();

    // cal order total
    FFAppState().Total +=
        int.parse(FFAppState().qttys[0]) * double.parse(FFAppState().prices[0]);
  }

  if (FFAppState().prices.length == 1 &&
      plus == false &&
      FFAppState().qttys[0] == 1) {
    print('remove when only 1 item');
    FFAppState().productName.removeAt(0);
    FFAppState().prices.removeAt(0);
    FFAppState().qttys.removeAt(0);
    FFAppState().productsids.removeAt(0);
  }

  for (int i = 0; i < FFAppState().prices.length; i++) {
    // cal product total
    FFAppState().procudtTotal[i] = (double.parse(FFAppState().prices[i]) *
            int.parse(FFAppState().qttys[i]))
        .toString();
    // cal order total
    FFAppState().Total +=
        int.parse(FFAppState().qttys[i]) * double.parse(FFAppState().prices[i]);
  }
}