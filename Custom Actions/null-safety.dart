// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=89KO7T-PeMM
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

Future nullSafety(
  String? str,
  int? integer,
  double? doubleit,
  bool? boolean,
  String? imgpath,
  String? videopath,
  String? audiopath,
  Color? color,
  DocumentReference? orderRef,
  OrdersRecord? orderDoc,
  dynamic jsonIt,
  DateTime? timestamp,
  DateTimeRange? timestampRange,
  LatLng? latlong,
  FFPlace? gPlaces,
  CarStruct? dt,
  UsersRow? sbRow,
  List<String>? names,
) async {
  // null safety check
  str = str ?? '';
  integer = integer ?? 0;
  doubleit = doubleit ?? 0.00;
  imgpath = imgpath ??
      'https://cdn.pixabay.com/photo/2016/11/19/12/24/path-1839000__340.jpg';
  videopath = videopath ??
      'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4';
  audiopath = audiopath ??
      'https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3';
  color = color ?? Colors.cyan;
  orderRef = orderRef ??
      FirebaseFirestore.instance.doc('/orders/20JprcSZFZjielfi1CA8');
  orderDoc = orderDoc ??
      createOrdersRecordData(name: 'demo', date: DateTime.now(), orderid: '0')
          as OrdersRecord;
  jsonIt = jsonIt ?? {};
  timestamp = timestamp ?? DateTime.now();
  timestampRange = timestampRange ?? RangeValues(0.0, 0.0) as DateTimeRange;
  latlong = latlong ?? LatLng(0.00, 0.00);
  gPlaces = gPlaces ??
      FFPlace(
          address: 'Grand Canary',
          city: 'Sofia',
          country: 'Bulgaria',
          latLng: LatLng(0.00, 0.00),
          name: 'St Sofia',
          state: 'Sofia',
          zipCode: '1000');
  dt = dt ??
      createCarStruct(
          brand: 'Kia',
          clearUnsetFields: true,
          color: Colors.blue,
          create: true,
          delete: false,
          doors: 4,
          fieldValues: {},
          onSale: true);
  sbRow = sbRow ?? UsersRow({});

  // add your code
}