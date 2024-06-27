import 'package:http/http.dart';

Future<StreamedResponse> getStreamedResponse(Request request) =>
    Client().send(request);
