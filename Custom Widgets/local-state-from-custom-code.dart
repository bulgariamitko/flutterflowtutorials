// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=_ik4paDX6VI
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

class ReachText2 extends StatefulWidget {
  const ReachText2({
    Key? key,
    this.width,
    this.height,
    this.currentText,
    required this.onSubmit,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? currentText;
  final Future<dynamic> Function() onSubmit;

  @override
  _ReachText2State createState() => _ReachText2State();
}

class _ReachText2State extends State<ReachText2> {
  @override
  Widget build(BuildContext context) {
    var myJSON = jsonDecode(widget.currentText ?? '');
    QuillController _controller = QuillController(
        document: Document.fromJson(myJSON),
        selection: TextSelection.collapsed(offset: 0));
    print(_controller.toString());
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
            ),
          ],
        ),
        FFButtonWidget(
          onPressed: () {
            var json = jsonEncode(_controller.document.toDelta().toJson());
            // FFAppState().name
          },
          text: 'SAVE',
          options: FFButtonOptions(
            width: 130,
            height: 40,
            color: FlutterFlowTheme.of(context).primaryColor,
            textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                  fontFamily: FlutterFlowTheme.of(context).subtitle2Family,
                  color: Colors.white,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                      FlutterFlowTheme.of(context).subtitle2Family),
                ),
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }
}
