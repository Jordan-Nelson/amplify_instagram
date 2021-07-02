import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class ImageObject {
  final String key;
  final String url;

  const ImageObject({required this.key, required this.url});

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImageObject && key == other.key && url == other.url;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("ImageObject {");
    buffer.write("id=" + "$key" + ", ");
    buffer.write("name=" + "$url" + ", ");
    buffer.write("}");

    return buffer.toString();
  }

  ImageObject copyWith({String? key, String? url}) {
    return ImageObject(
      key: key ?? this.key,
      url: url ?? this.url,
    );
  }

  ImageObject.fromJson(Map<String, dynamic> json)
      : key = json['key'],
        url = json['url'];

  factory ImageObject.fromJsonString(String string) =>
      ImageObject.fromJson(jsonDecode(string));

  Map<String, dynamic> toJson() => {
        'key': key,
        'url': url,
      };

  String toJsonString() => jsonEncode(toJson());
}
