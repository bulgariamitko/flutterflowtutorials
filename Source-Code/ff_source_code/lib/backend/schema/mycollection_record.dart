import 'dart:async';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MycollectionRecord extends FirestoreRecord {
  MycollectionRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "age" field.
  int? _age;
  int get age => _age ?? 0;
  bool hasAge() => _age != null;

  // "weight" field.
  double? _weight;
  double get weight => _weight ?? 0.0;
  bool hasWeight() => _weight != null;

  // "height" field.
  double? _height;
  double get height => _height ?? 0.0;
  bool hasHeight() => _height != null;

  // "eyeColor" field.
  String? _eyeColor;
  String get eyeColor => _eyeColor ?? '';
  bool hasEyeColor() => _eyeColor != null;

  // "hairColor" field.
  String? _hairColor;
  String get hairColor => _hairColor ?? '';
  bool hasHairColor() => _hairColor != null;

  // "imagePath" field.
  String? _imagePath;
  String get imagePath => _imagePath ?? '';
  bool hasImagePath() => _imagePath != null;

  // "videoPath" field.
  String? _videoPath;
  String get videoPath => _videoPath ?? '';
  bool hasVideoPath() => _videoPath != null;

  // "audioPath" field.
  String? _audioPath;
  String get audioPath => _audioPath ?? '';
  bool hasAudioPath() => _audioPath != null;

  // "dateTime" field.
  DateTime? _dateTime;
  DateTime? get dateTime => _dateTime;
  bool hasDateTime() => _dateTime != null;

  // "latLng" field.
  LatLng? _latLng;
  LatLng? get latLng => _latLng;
  bool hasLatLng() => _latLng != null;

  // "color" field.
  Color? _color;
  Color? get color => _color;
  bool hasColor() => _color != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _age = castToType<int>(snapshotData['age']);
    _weight = castToType<double>(snapshotData['weight']);
    _height = castToType<double>(snapshotData['height']);
    _eyeColor = snapshotData['eyeColor'] as String?;
    _hairColor = snapshotData['hairColor'] as String?;
    _imagePath = snapshotData['imagePath'] as String?;
    _videoPath = snapshotData['videoPath'] as String?;
    _audioPath = snapshotData['audioPath'] as String?;
    _dateTime = snapshotData['dateTime'] as DateTime?;
    _latLng = snapshotData['latLng'] as LatLng?;
    _color = getSchemaColor(snapshotData['color']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('mycollection');

  static Stream<MycollectionRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => MycollectionRecord.fromSnapshot(s));

  static Future<MycollectionRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => MycollectionRecord.fromSnapshot(s));

  static MycollectionRecord fromSnapshot(DocumentSnapshot snapshot) =>
      MycollectionRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static MycollectionRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      MycollectionRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'MycollectionRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is MycollectionRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createMycollectionRecordData({
  String? name,
  int? age,
  double? weight,
  double? height,
  String? eyeColor,
  String? hairColor,
  String? imagePath,
  String? videoPath,
  String? audioPath,
  DateTime? dateTime,
  LatLng? latLng,
  Color? color,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'eyeColor': eyeColor,
      'hairColor': hairColor,
      'imagePath': imagePath,
      'videoPath': videoPath,
      'audioPath': audioPath,
      'dateTime': dateTime,
      'latLng': latLng,
      'color': color,
    }.withoutNulls,
  );

  return firestoreData;
}
