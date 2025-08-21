// YouTube channel - https://www.youtube.com/@dimitarklaturov
// paid video - no
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({
    super.key,
    this.width,
    this.height,
    required this.barcodeDetectedCallback,
  });

  final double? width;
  final double? height;
  final Future Function(String barcodeN) barcodeDetectedCallback;

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  BarcodeScanner? _barcodeScanner;
  bool _isDetecting = false;
  String? _barcodeValue;
  List<Barcode> _barcodes = [];
  List<CameraDescription> cameras = [];
  bool _isFrontCamera = false;
  Size? _previewSize;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.all]);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _isDisposed = true;
    _stopImageStream();
    _cameraController?.dispose();
    _barcodeScanner?.close();
    super.dispose();
  }

  Future<void> _stopImageStream() async {
    try {
      if (_cameraController != null &&
          _cameraController!.value.isInitialized &&
          _cameraController!.value.isStreamingImages) {
        await _cameraController!.stopImageStream();
      }
    } catch (e) {
      print('Error stopping image stream: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _stopImageStream();
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  String _formatBarcodeValue(String? value) {
    if (value == null || value.isEmpty) return '';

    String digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.length <= 12) {
      digitsOnly = digitsOnly.padLeft(12, '0');
    } else if (digitsOnly.length <= 13) {
      digitsOnly = digitsOnly.padLeft(13, '0');
    }

    return digitsOnly;
  }

  Future<void> _switchCamera() async {
    if (_cameraController == null) return;

    setState(() {
      _barcodeValue = null;
      _barcodes = [];
      _isDetecting = true; // Prevent detection during switch
    });

    // First, properly cleanup existing camera
    try {
      // Stop the image stream first
      if (_cameraController!.value.isStreamingImages) {
        await _cameraController!.stopImageStream();
      }

      // Dispose the controller
      await _cameraController!.dispose();

      // Clear the controller reference
      _cameraController = null;
    } catch (e) {
      print('Error during camera cleanup: $e');
    }

    // Toggle camera direction
    _isFrontCamera = !_isFrontCamera;

    // Initialize new camera with retry mechanism
    int retryCount = 0;
    bool success = false;

    while (!success && retryCount < 3 && mounted) {
      try {
        // Make sure we have the camera list
        if (cameras.isEmpty) {
          cameras = await availableCameras();
        }

        // Find the requested camera
        final camera = _isFrontCamera
            ? cameras.firstWhere(
                (camera) => camera.lensDirection == CameraLensDirection.front,
                orElse: () => cameras.first,
              )
            : cameras.firstWhere(
                (camera) => camera.lensDirection == CameraLensDirection.back,
                orElse: () => cameras.first,
              );

        // Create and initialize new controller
        final newController = CameraController(
          camera,
          ResolutionPreset.high,
          enableAudio: false,
          imageFormatGroup: Platform.isAndroid
              ? ImageFormatGroup.nv21
              : ImageFormatGroup.bgra8888,
        );

        // Wait for controller to initialize
        await newController.initialize();

        if (mounted) {
          await newController.lockCaptureOrientation();
          _cameraController = newController;

          _previewSize = Size(
            _cameraController!.value.previewSize!.height,
            _cameraController!.value.previewSize!.width,
          );

          // Reset detection flag
          _isDetecting = false;

          setState(() {});

          // Small delay before starting stream
          await Future.delayed(const Duration(milliseconds: 1000));

          // Start the image stream
          _startImageStream();
          success = true;
        }
      } catch (e) {
        print('Camera initialization error (attempt ${retryCount + 1}): $e');
        retryCount++;
        await Future.delayed(const Duration(milliseconds: 1000));
      }
    }

    if (!success && mounted) {
      // If all retries failed, show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to switch camera. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
      _isDetecting = false;
    }
  }

  Future<void> _initializeCamera() async {
    if (_isDisposed) return;

    try {
      if (cameras.isEmpty) {
        cameras = await availableCameras();
        if (cameras.isEmpty) return;
      }

      final camera = _isFrontCamera
          ? cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.front,
              orElse: () => cameras.first,
            )
          : cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back,
              orElse: () => cameras.first,
            );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.unknown,
      );

      await _cameraController?.initialize();

      if (!_isDisposed && mounted) {
        await _cameraController?.lockCaptureOrientation();

        _previewSize = Size(
          _cameraController!.value.previewSize!.height,
          _cameraController!.value.previewSize!.width,
        );

        setState(() {});

        await Future.delayed(const Duration(milliseconds: 300));
        _isDetecting = false;
        _startImageStream();
      }
    } catch (e) {
      print('Camera initialization error: $e');
      _isDetecting = false;
    }
  }

  InputImage? _processCameraImage(CameraImage image) {
    if (_cameraController == null) return null;

    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final camera = _cameraController!.description;
      final sensorOrientation = camera.sensorOrientation;
      InputImageRotation rotation = InputImageRotation.rotation0deg;

      if (Platform.isAndroid) {
        rotation = InputImageRotation.values[sensorOrientation ~/ 90];
      }

      final format = Platform.isAndroid
          ? InputImageFormat.nv21
          : InputImageFormat.bgra8888;

      final inputImageMetadata = InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      );

      return InputImage.fromBytes(bytes: bytes, metadata: inputImageMetadata);
    } catch (e) {
      print('Error processing camera image: $e');
      return null;
    }
  }

  void _startImageStream() {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _cameraController!.value.isStreamingImages)
      return;

    try {
      _cameraController!.startImageStream((CameraImage image) async {
        if (_isDetecting) return;
        _isDetecting = true;

        try {
          final inputImage = _processCameraImage(image);
          if (inputImage == null) return;

          final barcodes =
              await _barcodeScanner?.processImage(inputImage) ?? [];

          if (mounted && !_isDisposed) {
            setState(() {
              _barcodes = barcodes;
              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                String rawValue = barcodes.first.rawValue!;
                BarcodeFormat format = barcodes.first.format;

                if (format == BarcodeFormat.upca) {
                  _barcodeValue = rawValue.padLeft(12, '0');
                } else if (format == BarcodeFormat.ean13) {
                  _barcodeValue = rawValue.padLeft(13, '0');
                } else {
                  _barcodeValue = rawValue;
                }
              }
            });
          }
        } catch (e) {
          print('Barcode processing error: $e');
        } finally {
          await Future.delayed(const Duration(milliseconds: 300));
          if (mounted) {
            _isDetecting = false;
          }
        }
      });
    } catch (e) {
      print('Error starting image stream: $e');
      _isDetecting = false;
    }
  }

  String _formatDisplayValue(String? value) {
    if (value == null || value.isEmpty) return '';
    String digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length < 13) {
      return digitsOnly.padLeft(13, '0');
    } else {
      return digitsOnly;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null ||
        !mounted ||
        !_cameraController!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final displayValue = _formatDisplayValue(_barcodeValue);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_cameraController!),
          if (_previewSize != null && mounted)
            CustomPaint(
              painter: BarcodePainter(
                barcodes: _barcodes,
                previewSize: _previewSize!,
                screenSize: MediaQuery.of(context).size,
              ),
              child: Container(),
            ),
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(
                Icons.flip_camera_ios,
                color: Colors.white,
                size: 30,
              ),
              onPressed: _switchCamera,
            ),
          ),
          if (displayValue.isNotEmpty)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                color: Colors.black54,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Barcode: $displayValue',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () async {
                        if (displayValue.isNotEmpty) {
                          // Stop detection and image stream
                          _isDetecting = true;
                          try {
                            // Stop the image stream
                            if (_cameraController?.value.isStreamingImages ??
                                false) {
                              await _cameraController?.stopImageStream();
                            }

                            // Close the barcode scanner
                            await _barcodeScanner?.close();

                            // Dispose of the camera controller
                            await _cameraController?.dispose();

                            // Clear resources
                            setState(() {
                              _cameraController = null;
                              _barcodeScanner = null;
                              _barcodes = [];
                              _barcodeValue = null;
                              _previewSize = null;
                            });

                            // Small delay to ensure cleanup
                            await Future.delayed(
                              const Duration(milliseconds: 300),
                            );

                            // Now execute the callback
                            await widget.barcodeDetectedCallback(displayValue);
                          } catch (e) {
                            print('Error during cleanup: $e');
                            // Still execute callback even if cleanup has errors
                            await widget.barcodeDetectedCallback(displayValue);
                          }
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class BarcodePainter extends CustomPainter {
  final List<Barcode> barcodes;
  final Size previewSize;
  final Size screenSize;

  BarcodePainter({
    required this.barcodes,
    required this.previewSize,
    required this.screenSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final barcode in barcodes) {
      if (barcode.boundingBox == null) continue;

      final scaleX = screenSize.width / previewSize.width;
      final scaleY = screenSize.height / previewSize.height;

      final rect = Rect.fromLTRB(
        barcode.boundingBox!.left * scaleX,
        barcode.boundingBox!.top * scaleY,
        barcode.boundingBox!.right * scaleX,
        barcode.boundingBox!.bottom * scaleY,
      );

      const cornerLength = 30.0;
      const strokeWidth = 4.0;

      final backgroundPaint = Paint()
        ..color = Colors.black
        ..strokeWidth = strokeWidth + 2
        ..style = PaintingStyle.stroke;

      final foregroundPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;

      void drawCorner(Offset start, Offset end1, Offset end2) {
        canvas.drawLine(start, end1, backgroundPaint);
        canvas.drawLine(start, end2, backgroundPaint);

        canvas.drawLine(start, end1, foregroundPaint);
        canvas.drawLine(start, end2, foregroundPaint);
      }

      drawCorner(
        rect.topLeft,
        rect.topLeft.translate(cornerLength, 0),
        rect.topLeft.translate(0, cornerLength),
      );

      drawCorner(
        rect.topRight,
        rect.topRight.translate(-cornerLength, 0),
        rect.topRight.translate(0, cornerLength),
      );

      drawCorner(
        rect.bottomLeft,
        rect.bottomLeft.translate(cornerLength, 0),
        rect.bottomLeft.translate(0, -cornerLength),
      );

      drawCorner(
        rect.bottomRight,
        rect.bottomRight.translate(-cornerLength, 0),
        rect.bottomRight.translate(0, -cornerLength),
      );
    }
  }

  @override
  bool shouldRepaint(BarcodePainter oldDelegate) {
    return oldDelegate.barcodes != barcodes;
  }
}
