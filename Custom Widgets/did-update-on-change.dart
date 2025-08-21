// YouTube channel - https://www.youtube.com/@dimitarklaturov
// paid video -
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

class WidgetLister extends StatefulWidget {
  const WidgetLister({
    super.key,
    this.width,
    this.height,
    this.listening,
    required this.myAction,
  });

  final double? width;
  final double? height;
  final ListeningRecord? listening;
  final Future Function() myAction;

  @override
  State<WidgetLister> createState() => _WidgetListerState();
}

class _WidgetListerState extends State<WidgetLister> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant WidgetLister oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.listening!.changer) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.myAction.call();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('');
  }
}
