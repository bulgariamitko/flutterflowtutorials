// code created by https://www.youtube.com/@flutterflowexpert

Future navToPage(
  BuildContext context,
  String page,
  String id,
) async {
  // nav without parameters
  // context.pushNamed(page);

  // nav with params
  context.pushNamed(
    page,
    queryParams: {
      // TODO: Change the name of the parameter - 'id'
      'id': serializeParam(
        id,
        ParamType.String,
      ),
      // If you have more then 1 parameter
      // 'name': serializeParam(
      //   id,
      //   ParamType.String,
      // ),
    }.withoutNulls,
  );
}