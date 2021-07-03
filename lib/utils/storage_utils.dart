import 'dart:io';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:image_picker/image_picker.dart';

final ImagePicker _picker = ImagePicker();
StorageAccessLevel postAccessLevel = StorageAccessLevel.protected;

Future<List<File>> pickImages() async {
  final pickedFileList = await _picker.getMultiImage();
  if (pickedFileList != null && pickedFileList.isNotEmpty) {
    return pickedFileList.map((pickedFile) => File(pickedFile.path)).toList();
  }
  return [];
}

Future<String> uploadImage({
  required File file,
  required String postId,
}) async {
  String id = UUID.getUUID();
  String dir = 'posts/';
  String key = dir + postId + '/' + id;

  await Amplify.Storage.uploadFile(
    local: file,
    key: key,
    options: S3UploadFileOptions(
      accessLevel: postAccessLevel,
    ),
  );

  return key;
}

Future<String> getImageUrl(String imageKey) {
  return Amplify.Storage.getUrl(
    key: imageKey,
    options: GetUrlOptions(
      accessLevel: postAccessLevel,
      expires: 604800,
    ),
  ).then((value) {
    return value.url;
  }).catchError((error) {
    print('error');
  });
}
