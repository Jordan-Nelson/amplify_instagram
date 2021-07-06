import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class ImageObject {
  final String key;
  final String identityId;

  const ImageObject({required this.key, required this.identityId});

  bool equals(Object other) {
    return this == other;
  }

  String get cacheKey => this.identityId + '/' + this.key;

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImageObject &&
        key == other.key &&
        identityId == other.identityId;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("ImageObject {");
    buffer.write("id=" + "$key" + ", ");
    buffer.write("identityId=" + "$identityId" + ", ");
    buffer.write("}");

    return buffer.toString();
  }

  ImageObject copyWith({String? key, String? identityId}) {
    return ImageObject(
      key: key ?? this.key,
      identityId: identityId ?? this.identityId,
    );
  }

  ImageObject.fromJson(Map<String, dynamic> json)
      : key = json['key'],
        identityId = json['identityId'];

  factory ImageObject.fromJsonString(String string) =>
      ImageObject.fromJson(jsonDecode(string));

  Map<String, dynamic> toJson() => {
        'key': key,
        'identityId': identityId,
      };

  String toJsonString() => jsonEncode(toJson());
}
