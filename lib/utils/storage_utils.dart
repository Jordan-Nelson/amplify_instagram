import 'dart:io';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_instagram/custom_models/ImageObject.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:image_picker/image_picker.dart';

final ImagePicker _picker = ImagePicker();

Future<List<File>> pickImages() async {
  final pickedFileList = await _picker.getMultiImage();
  if (pickedFileList != null && pickedFileList.isNotEmpty) {
    return pickedFileList.map((pickedFile) => File(pickedFile.path)).toList();
  }
  return [];
}

Future<ImageObject> uploadImage({
  required File file,
  required String postId,
}) async {
  String id = UUID.getUUID();
  String dir = 'posts/';
  String key = dir + postId + '/' + id;
  StorageAccessLevel accessLevel = StorageAccessLevel.protected;

  await Amplify.Storage.uploadFile(
    local: file,
    key: key,
    options: S3UploadFileOptions(
      accessLevel: accessLevel,
    ),
  );

  GetUrlResult result = await Amplify.Storage.getUrl(
    key: key,
    options: GetUrlOptions(accessLevel: accessLevel),
  );
  return ImageObject(key: key, url: result.url);
}
