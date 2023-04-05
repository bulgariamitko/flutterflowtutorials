// code created by https://www.youtube.com/@flutterflowexpert
// video -
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

import 'package:webviewx/webviewx.dart';

class CustumWebView extends StatefulWidget {
  const CustumWebView({
    Key key,
    @required this.urlthis,
    this.width,
    this.height,
    this.bypass = false,
    this.horizontalScroll = false,
    this.verticalScroll = false,
    this.jsContent,
  }) : super(key: key);

  final bool bypass;
  final bool horizontalScroll;
  final bool verticalScroll;
  final double height;
  final double width;
  final String urlthis;
  final String jsContent;

  @override
  _CustumWebViewState createState() => _CustumWebViewState();
}

class _CustumWebViewState extends State<CustumWebView> {
  @override
  Widget build(BuildContext context) {
    Object converted = json.decode(widget.jsContent);
    Set<EmbeddedJsContent> jsContentConverted = converted;
    WebViewX(
      jsContent: jsContentConverted,
      key: webviewKey,
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height ?? MediaQuery.of(context).size.height,
      ignoreAllGestures: false,
      initialContent: widget.urlthis,
      initialMediaPlaybackPolicy:
          AutoMediaPlaybackPolicy.requireUserActionForAllMediaTypes,
      initialSourceType: widget.bypass ? SourceType.urlBypass : SourceType.html,
      javascriptMode: JavascriptMode.unrestricted,
      webSpecificParams: const WebSpecificParams(
        webAllowFullscreenContent: true,
      ),
      mobileSpecificParams: MobileSpecificParams(
        debuggingEnabled: false,
        gestureNavigationEnabled: true,
        mobileGestureRecognizers: {
          if (widget.verticalScroll)
            Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer(),
            ),
          if (widget.horizontalScroll)
            Factory<HorizontalDragGestureRecognizer>(
              () => HorizontalDragGestureRecognizer(),
            ),
        },
        androidEnableHybridComposition: true,
      ),
    );
  }

  Key get webviewKey => Key(
        [
          widget.urlthis,
          widget.width,
          widget.height,
          widget.bypass,
          widget.horizontalScroll,
          widget.verticalScroll,
          widget.jsContent,
        ].map((s) => s?.toString() ?? '').join(),
      );
}
