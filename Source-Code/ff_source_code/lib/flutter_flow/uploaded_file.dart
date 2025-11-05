import 'dart:convert';
import 'dart:typed_data' show Uint8List;

class FFUploadedFile {
  const FFUploadedFile({
    this.name,
    this.bytes,
    this.height,
    this.width,
    this.blurHash,
    this.originalFilename = '',
  });

  final String? name;
  final Uint8List? bytes;
  final double? height;
  final double? width;
  final String? blurHash;
  final String originalFilename;

  @override
  String toString() =>
      'FFUploadedFile(name: $name, bytes: ${bytes?.length ?? 0}, height: $height, width: $width, blurHash: $blurHash, originalFilename: $originalFilename,)';

  String serialize() => jsonEncode(
        {
          'name': name,
          'bytes': bytes,
          'height': height,
          'width': width,
          'blurHash': blurHash,
          'originalFilename': originalFilename,
        },
      );

  static FFUploadedFile deserialize(String val) {
    final serializedData = jsonDecode(val) as Map<String, dynamic>;
    final data = {
      'name': serializedData['name'] ?? '',
      'bytes': serializedData['bytes'] ?? Uint8List.fromList([]),
      'height': serializedData['height'],
      'width': serializedData['width'],
      'blurHash': serializedData['blurHash'],
      'originalFilename': serializedData['originalFilename'] ?? '',
    };
    return FFUploadedFile(
      name: data['name'] as String,
      bytes: Uint8List.fromList(data['bytes'].cast<int>().toList()),
      height: data['height'] as double?,
      width: data['width'] as double?,
      blurHash: data['blurHash'] as String?,
      originalFilename: data['originalFilename'] as String,
    );
  }

  @override
  int get hashCode => Object.hash(
        name,
        bytes,
        height,
        width,
        blurHash,
        originalFilename,
      );

  @override
  bool operator ==(other) =>
      other is FFUploadedFile &&
      name == other.name &&
      bytes == other.bytes &&
      height == other.height &&
      width == other.width &&
      blurHash == other.blurHash &&
      originalFilename == other.originalFilename;
}
