import '../../../flutter_flow/upload_data.dart';
import '../supabase.dart';

Future<List<String>> uploadSupabaseStorageFiles({
  required String bucketName,
  required List<SelectedMedia> selectedMedia,
}) =>
    Future.wait(
      selectedMedia.map(
        (media) => uploadSupabaseStorageFile(
          bucketName: bucketName,
          selectedMedia: media,
        ),
      ),
    );

Future<String> uploadSupabaseStorageFile({
  required String bucketName,
  required SelectedMedia selectedMedia,
}) async {
  final storageBucket = SupaFlow.client.storage.from(bucketName);
  await storageBucket.uploadBinary(
    selectedMedia.storagePath,
    selectedMedia.bytes,
    fileOptions: FileOptions(contentType: null),
  );
  return storageBucket.getPublicUrl(selectedMedia.storagePath);
}

Future deleteSupabaseFileFromPublicUrl(String publicUrl) async {
  final storagePath = SupaFlow.client.storage.pathFromPublicUrl(publicUrl);
  if (storagePath == null) {
    return;
  }

  final bucketName = storagePath.split('/').first;
  final filePath = storagePath.split('/').skip(1).join('/');
  await SupaFlow.client.storage.from(bucketName).remove([filePath]);
}

extension _SupabaseBucketExtensions on SupabaseStorageClient {
  String? pathFromPublicUrl(String publicUrl) {
    final publicUrlPrefix = '$url/object/public/';
    final urlParts = publicUrl.split(publicUrlPrefix);
    if (urlParts.length != 2) {
      return null;
    }
    final fullStoragePath = urlParts.last;
    final storagePathParts = fullStoragePath.split('/');
    if (storagePathParts.length <= 1) {
      return null;
    }
    return fullStoragePath;
  }
}
