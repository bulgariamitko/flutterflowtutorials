// code created by https://www.youtube.com/@flutterflowexpert
// video -

import '../../auth/email_auth.dart';
import '../../welcome/welcome_widget.dart';

Future customRegistration(BuildContext context, String email) async {
  final user = await createAccountWithEmail(
    context,
    email,
    'demoPass123456',
  );
  if (user == null) {
    return;
  }
  await Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => WelcomeWidget(),
    ),
    (r) => false,
  );
}

// custom login

import '../../auth/auth_util.dart';
import '../../auth/email_auth.dart';
import '../../welcome/welcome_widget.dart';
import '../../backend/api_requests/api_calls.dart';

Future customLogin(BuildContext context, String email) async {
  await LoginUserCall.call(
    loginUser: true,
  );
  final user = await signInWithEmail(
    context,
    email,
    'demoPass123456',
  );
  if (user == null) {
    return;
  }
  await Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => WelcomeWidget(),
    ),
    (r) => false,
  );
}

// redirect admin's to a new page

import 'package:demoo998899/upload_succ/upload_succ_widget.dart';
// import '../../upload_succ/upload_succ_widget.dart';
import '../../auth/auth_util.dart';

Future ifAdmin(BuildContext context, bool admin) async {
  if (currentUserDocument.admin != null && currentUserDocument.admin) {
    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => UploadSuccWidget(),
      ),
          (r) => false,
    );
  }
}

// accept any data type in your API calls

import '../../backend/api_requests/api_calls.dart';
import '../../backend/api_requests/api_manager.dart';

class UseJSONDataTypeCall {
  static Future<ApiCallResponse> call({
    dynamic data = '',
    String job = '',
  }) {
    return ApiManager.instance.makeApiCall(
      callName: 'use JSON',
      apiUrl: 'https://reqres.in/api/users',
      callType: ApiCallType.POST,
      headers: {},
      params: {
        'name': data,
        'job': job,
      },
      bodyType: BodyType.JSON,
      returnBody: true,
    );
  }
}

// Begin custom action code
Future<dynamic> jsonDateType(BuildContext context, dynamic jsonData) async {
  final returnData = UseJSONDataTypeCall.call(
    data: 'nameit',
    job: 'jobit',
  );

  return returnData;
}