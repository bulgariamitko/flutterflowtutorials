// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - no
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

// code provided by - darkmoon3d (I havent tested the code yet)

import 'dart:async';
import 'dart:typed_data';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';

////////////

class USBSerialWidget extends StatefulWidget {
  const USBSerialWidget({
    Key? key,
    this.width,
    this.height,
    required this.rebuildpage,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Future<dynamic> Function() rebuildpage;

  @override
  _USBSerialWidgetState createState() => _USBSerialWidgetState();
}

////////////

class _USBSerialWidgetState extends State<USBSerialWidget> {
  UsbPort? _port;
  List<Widget> _ports = [];
  late String _serialDataString = "";
  bool _isConnected = false;

  StreamSubscription<String>? _subscription;
  Transaction<String>? _transaction;
  UsbDevice? _device;

  ////////////

  String getTimestamp() {
    DateTime now = DateTime.now();
    String timestamp =
        '[${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}.'
        '${now.millisecond.toString().padLeft(3, '0')}] - ';
    return timestamp;
  }

  ////////////

  Future<bool> _connectTo(device) async {
    _serialDataString = "";

    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }

    if (_transaction != null) {
      _transaction!.dispose();
      _transaction = null;
    }

    if (_port != null) {
      _port!.close();
      _port = null;
    }

    if (device == null) {
      _device = null;

      setState(() {
        _isConnected = false;
        FFAppState().update(() {
          FFAppState().USBstatus = "Disconnected";
          FFAppState().USBconnectedSerialID = device.serial!;
        });
      });
      return true;
    }

    _port = await device.create();
    if (await (_port!.open()) != true) {
      setState(() {
        _isConnected = false;
        FFAppState().update(() {
          FFAppState().USBstatus = "Disconnected";
        });
      });
      return false;
    }
    _device = device;

    await _port!.setDTR(true);
    await _port!.setRTS(true);
    await _port!.setPortParameters(
      115200,
      UsbPort.DATABITS_8,
      UsbPort.STOPBITS_1,
      UsbPort.PARITY_NONE,
    );

    _transaction = Transaction.stringTerminated(
      _port!.inputStream as Stream<Uint8List>,
      Uint8List.fromList([13, 10]),
    );

    _subscription = _transaction!.stream.listen((String line) {
      setState(() {
        _serialDataString = line;

        if (!FFAppState().showTimestamp) {
          _serialDataString = '${getTimestamp()} $_serialDataString';
        }

        FFAppState().update(() {
          FFAppState().USBserialDataString = _serialDataString;
        });
      });
    });

    setState(() {
      _isConnected = true;
      FFAppState().update(() {
        FFAppState().USBstatus = "Connected";
        FFAppState().USBconnectedSerialID = device.serial!;
      });
    });
    return true;
  }

  ////////////

  void _getPorts() async {
    _ports = [];
    List<UsbDevice> devices = await UsbSerial.listDevices();

    if (!devices.contains(_device)) {
      _connectTo(null);
    }

    devices.forEach((device) {
      _ports.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Container(
            width: 350,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Align(
              alignment: AlignmentDirectional(0, 0),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            device.productName!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                device.manufacturerName!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0, 0),
                                child: Text(
                                  device.serial!,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(width: 50)),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: _device == device
                            ? MaterialStateProperty.all(Colors.green)
                            : MaterialStateProperty.all(Colors.blue),
                        minimumSize: MaterialStateProperty.all(Size(80, 40)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      child: Icon(
                        _device == device ? Icons.link_off : Icons.link,
                        color: Colors.white,
                        size: 25,
                      ),
                      onPressed: () {
                        _connectTo(_device == device ? device : null).then((
                          res,
                        ) {
                          _getPorts();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });

    setState(() {});
  }

  ////////////

  @override
  void initState() {
    super.initState();

    UsbSerial.usbEventStream!.listen((UsbEvent event) async {
      _getPorts();
      await widget.rebuildpage();
    });

    _getPorts();
  }

  ////////////

  @override
  void dispose() {
    super.dispose();
    _connectTo(null);
  }

  ////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(children: <Widget>[..._ports])),
    );
  }
}
