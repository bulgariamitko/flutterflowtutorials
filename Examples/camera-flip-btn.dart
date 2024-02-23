// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

class _CameraPhotoState extends State<CameraPhoto> {
  CameraController? controller;
  late Future<List<CameraDescription>> _cameras;
  List<CameraDescription>? camerasList;
  int selectedCameraIndex =
      0; // Keep track of the selected camera, 0 is the back camera, 1 is typically the front.

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  Future<void> _initializeCameras() async {
    camerasList = await availableCameras();
    _initCameraController(camerasList![selectedCameraIndex]);
  }

  Future<void> _initCameraController(
      CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.max);

    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  void _onSwitchCamera() {
    selectedCameraIndex = (selectedCameraIndex + 1) %
        camerasList!.length; // Switch between cameras.
    _initCameraController(camerasList![selectedCameraIndex]);
  }

  // The rest of your code remains unchanged

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CameraDescription>>(
      future: _cameras,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return controller!.value.isInitialized
                ? Stack(
                    children: [
                      MaterialApp(
                        home: CameraPreview(controller!),
                      ),
                      Positioned(
                        top: 30,
                        right: 30,
                        child: FloatingActionButton(
                          child: Icon(Icons.flip_camera_android),
                          onPressed: _onSwitchCamera,
                        ),
                      )
                    ],
                  )
                : Container();
          } else {
            return Center(child: Text('No cameras available.'));
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
