import 'dart:convert';
import 'dart:math' as math;


String base64Encodefunction(
  String username,
  String password,
) {

  String base64 = base64Encode(utf8.encode('$username:$password'));
  return base64;

}
