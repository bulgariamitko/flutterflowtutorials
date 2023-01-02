// code created by https://www.youtube.com/@flutterflowexpert

import 'package:webviewx/webviewx.dart';

class CustomWebView extends StatefulWidget {
  const CustomWebView({
    Key key,
    @required this.url,
    this.width,
    this.height,
    this.bypass = false,
    this.horizontalScroll = false,
    this.verticalScroll = false,
  }) : super(key: key);

  final bool bypass;
  final bool horizontalScroll;
  final bool verticalScroll;
  final double height;
  final double width;
  final String url;

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  @override
  Widget build(BuildContext context) => WebViewX(
        key: webviewKey,
        width: widget.width ?? MediaQuery.of(context).size.width,
        height: widget.height ?? MediaQuery.of(context).size.height,
        ignoreAllGestures: false,
        initialContent: widget.url,
        initialMediaPlaybackPolicy:
            AutoMediaPlaybackPolicy.requireUserActionForAllMediaTypes,
        initialSourceType:
            widget.bypass ? SourceType.urlBypass : SourceType.url,
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

  Key get webviewKey => Key(
        [
          widget.url,
          widget.width,
          widget.height,
          widget.bypass,
          widget.horizontalScroll,
          widget.verticalScroll,
        ].map((s) => s?.toString() ?? '').join(),
      );
}
