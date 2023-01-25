// code created by https://www.youtube.com/@flutterflowexpert

import 'package:html_editor_enhanced/html_editor.dart';

class MyHtmlEditor extends StatefulWidget {
  const MyHtmlEditor({
    Key? key,
    this.width,
    this.height,
    this.currentHtml,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? currentHtml;

  @override
  _MyHtmlEditorState createState() => _MyHtmlEditorState();
}

class _MyHtmlEditorState extends State<MyHtmlEditor> {
  HtmlEditorController controller = HtmlEditorController();

  // Get a reference to the Firestore database
  final firestore = FirebaseFirestore.instance;

  // Get a reference to the collection
  late final CollectionReference<Object?> collectionRef;

  @override
  void initState() {
    super.initState();
    // Initialize the collection reference
    collectionRef = firestore.collection('htmleditor');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        HtmlEditor(
          controller: controller, //required
          htmlEditorOptions: HtmlEditorOptions(
            hint: "Type your Text here",
            initialText: widget.currentHtml,
          ),
          htmlToolbarOptions: HtmlToolbarOptions(
            toolbarType: ToolbarType.nativeGrid,
          ),
          otherOptions: OtherOptions(
            height: 400,
          ),
        ),
        ElevatedButton(
            onPressed: () async {
              String data = await controller.getText();
              // save to Firebase
              final doc = createHtmleditorRecordData(text: data);

              collectionRef.limit(1).get().then((snapshot) {
                if (snapshot.docs.isNotEmpty) {
                  // update document
                  final docRef = snapshot.docs[0].reference;
                  docRef.update(doc);
                } else {
                  // create document
                  collectionRef.add(doc);
                }
              });

              // nav to a new page
              //   context.pushNamed(
              //     'actions',
              //     queryParams: {
              //       // TODO: Change the name of the parameter - 'id'
              //       'id': serializeParam(
              //         33,
              //         ParamType.String,
              //       ),
              //     }.withoutNulls,
              //   );
              // });

              // Update local state
              FFAppState().update(() {
                setState(() => FFAppState().textFromHtmlEditor = data);
              });
            },
            child: Text("SAVE TEXT *"));
      ],
    ));
  }
}