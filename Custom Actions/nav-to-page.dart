// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=-PbOmjEsKxE
// widgets - Cg9Db2x1bW5fMHZ4dzJ5ZzUS0gEKEURyb3BEb3duXzl4cDVxZm52GCIiuAGqArEBGhYKCQkAAAAAAIBmQBIJCQAAAAAAAElAKgYI/////w8xAAAAAAAAAEA5AAAAAAAAAABCAggASQAAAAAAAAAAUgo6BgiAgID4D0AGWiQJAAAAAAAAKEARAAAAAAAAEEAZAAAAAAAAKEAhAAAAAAAAEEBgAXoWCghPcHRpb24gMXoKEghvdzczanZiaIIBHgoQUGxlYXNlIHNlbGVjdC4uLnoKEgg0YnJuY3cyb4oBAhIA+gMAYgASLQoRQ2hlY2tib3hfbGx1aThxYmUYSSIU+gMAigUOCAESBgj169f/DyICEAFiABIiCg9Td2l0Y2hfcTg5MDR4OHgYSCILiAMC+gMAggUCCAFiABJjChdTd2l0Y2hMaXN0VGlsZV9uaGp0dGQ5bxgdIkT6ATsIARIVCgVUaXRsZUADegoSCHZzdHE5ODBpGhgKCFN1YnRpdGxlQAV6ChIIMWVrbXcwdWEyBgj169f/D4gDAvoDAGIAEtABChRDaG9pY2VDaGlwc18xemF0ZWE2MRgyIrMBugOsARI/EiUI2OgDEg1NYXRlcmlhbEljb25zIAAyDnRyYWluX291dGxpbmVkGhYKCE9wdGlvbiAxegoSCG5sNGl6OHVrGi4KBgjF9sj5DxIKOgYI/////w9ABhoGCP////8PIQAAAAAAADJAMQAAAAAAABBAIi4KBgj/////DxIKOgYIxfbI+Q9ABxoGCMX2yPkPIQAAAAAAADJAMQAAAAAAABBAKQAAAAAAADRAUAb6AwBiABLSAgoYQ291bnRDb250cm9sbGVyXzJmcWNucndpGDAisQKqA6oCCAAQABgBMlEKPgjo4AMSEEZvbnRBd2Vzb21lU29saWQaFGZvbnRfYXdlc29tZV9mbHV0dGVyIAAqBwoFbWludXMyBW1pbnVzEQAAAAAAADRAIgYIgICA6A06TQo6CCsSEEZvbnRBd2Vzb21lU29saWQaFGZvbnRfYXdlc29tZV9mbHV0dGVyIAAqBgoEcGx1czIEcGx1cxEAAAAAAAA0QCIGCPOthvkPQgYI7t27/w9KGxEAAAAAAAAwQBoGUm9ib3RvKAY6BgiAgID4D1JbChYKCQkAAAAAAABkQBIJCQAAAAAAAElAEkESJAkAAAAAAAA5QBEAAAAAAAA5QBkAAAAAAAA5QCEAAAAAAAA5QCgBOQAAAAAAAPA/QgYI/////w9KBgievfr8D/oDAGIAEo4BCg1UZXh0X2I2cDM3a2x1GAIieRInCgtIZWxsbyBXb3JsZBEAAAAAAABBQEAGegoSCGphY255bXI3qAEAWgkRAAAAAAAANECaAT8KAgIBKjkIClI1CgASDgoMEgpUaGUgSUQgaXMgEiESHwgDEhFTY2FmZm9sZF9zMTJhOWc5OUIIMgYKBAoCaWT6AwBiABJkChJUZXh0RmllbGRfZWlyMnJmMTIYECJKigFECgJABhImCAKCASEKE1tTb21lIGhpbnQgdGV4dC4uLl16ChIIbzdzbjJpbzYYAUoREQAAAAAAADZAIgYI9erV+w+AAQH6AwBiABgEIgUiAPoDAA==
// replace - [{"Page parameter name": "id"}]
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

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