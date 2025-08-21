// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - no
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'dart:ffi';

class ListenForOrientationChange extends StatefulWidget {
  const ListenForOrientationChange({
    super.key,
    this.width,
    this.height,
    required this.runAction,
  });

  final double? width;
  final double? height;
  final Future Function(String orientation) runAction;

  @override
  State<ListenForOrientationChange> createState() =>
      _ListenForOrientationChangeState();
}

class _ListenForOrientationChangeState extends State<ListenForOrientationChange>
    with WidgetsBindingObserver {
  Orientation? _lastOrientation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (!mounted) return;
    final orientation = MediaQuery.of(context).orientation;
    if (_lastOrientation != orientation) {
      _lastOrientation = orientation;
      // Trigger your action here
      print('Orientation changed to: $orientation');
      if (orientation == Orientation.portrait) {
        widget.runAction.call('Portrait');
        print('Changed to Portrait Mode');
      } else {
        widget.runAction.call('Landscape');
        print('Changed to Landscape Mode');
      }
      // For example, call a function or use a callback to perform an action
      // onOrientationChanged(orientation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
