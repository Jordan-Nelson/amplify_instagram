import 'dart:io';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_instagram/app_models/image_object.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:image_picker/image_picker.dart';

import 'user_utils.dart';

final ImagePicker _picker = ImagePicker();
StorageAccessLevel postAccessLevel = StorageAccessLevel.protected;

Future<List<File>> pickImages() async {
  // TODO: resize images in a lamda
  final pickedFileList = await _picker.getMultiImage(maxWidth: 375);
  if (pickedFileList != null && pickedFileList.isNotEmpty) {
    return pickedFileList.map((pickedFile) => File(pickedFile.path)).toList();
  }
  return [];
}

Future<ImageObject> uploadImage({
  required File file,
  required String postId,
  required String userId,
}) async {
  String id = UUID.getUUID();
  String dir = 'posts/';
  String key = dir + postId + '/' + id;

  String identityId = await getCurrentUserIdentityId();

  await Amplify.Storage.uploadFile(
    local: file,
    key: key,
    options: S3UploadFileOptions(
      accessLevel: postAccessLevel,
    ),
  );

  return ImageObject(key: key, identityId: identityId);
}

Map<String, String> _imageKeyCache = {};

String? getImageUrlFromCache(ImageObject imageObject) {
  return _imageKeyCache[imageObject.cacheKey];
}

Future<String> getImageUrl(ImageObject imageObject) {
  String? cachedUrl = getImageUrlFromCache(imageObject);
  if (cachedUrl is String) {
    return Future.value(cachedUrl);
  }
  return Amplify.Storage.getUrl(
    key: imageObject.key,
    options: S3GetUrlOptions(
      accessLevel: postAccessLevel,
      expires: 604800,
      targetIdentityId: imageObject.identityId,
    ),
  ).then((value) {
    print(value.url);
    _imageKeyCache[imageObject.cacheKey] = value.url;
    return value.url;
  }).catchError((error) {
    print('error');
  });
}
