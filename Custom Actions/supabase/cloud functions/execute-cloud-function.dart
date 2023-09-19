// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

Future executeCloudFunction(
  String? paramName1,
  String? paramName2,
  String? paramValue1,
  String? paramValue2,
) async {
  // null safety
  paramName1 ??= 'error';
  paramName2 ??= 'error';
  paramValue1 ??= 'error';
  paramValue2 ??= 'error';

  final supabase = SupaFlow.client;

  final String rpcName = 'function_name';
  final Map<String, dynamic> rpcParams = {
    paramName1: paramValue1,
    paramName2: paramValue2,
  };

  final response = await supabase.rpc(rpcName, params: rpcParams);
}