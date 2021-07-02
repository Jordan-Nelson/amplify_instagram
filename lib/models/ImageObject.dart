/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// ignore_for_file: public_member_api_docs

import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the ImageObject type in your schema. */
@immutable
class ImageObject extends Model {
  static const classType = const _ImageObjectModelType();
  final String id;
  final String? _key;
  final String? _url;
  final String? _postImagesId;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String get key {
    try {
      return _key!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  String get url {
    try {
      return _url!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  String? get postImagesId {
    return _postImagesId;
  }
  
  const ImageObject._internal({required this.id, required key, required url, postImagesId}): _key = key, _url = url, _postImagesId = postImagesId;
  
  factory ImageObject({String? id, required String key, required String url, String? postImagesId}) {
    return ImageObject._internal(
      id: id == null ? UUID.getUUID() : id,
      key: key,
      url: url,
      postImagesId: postImagesId);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImageObject &&
      id == other.id &&
      _key == other._key &&
      _url == other._url &&
      _postImagesId == other._postImagesId;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ImageObject {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("key=" + "$_key" + ", ");
    buffer.write("url=" + "$_url" + ", ");
    buffer.write("postImagesId=" + "$_postImagesId");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ImageObject copyWith({String? id, String? key, String? url, String? postImagesId}) {
    return ImageObject(
      id: id ?? this.id,
      key: key ?? this.key,
      url: url ?? this.url,
      postImagesId: postImagesId ?? this.postImagesId);
  }
  
  ImageObject.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _key = json['key'],
      _url = json['url'],
      _postImagesId = json['postImagesId'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'key': _key, 'url': _url, 'postImagesId': _postImagesId
  };

  static final QueryField ID = QueryField(fieldName: "imageObject.id");
  static final QueryField KEY = QueryField(fieldName: "key");
  static final QueryField URL = QueryField(fieldName: "url");
  static final QueryField POSTIMAGESID = QueryField(fieldName: "postImagesId");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ImageObject";
    modelSchemaDefinition.pluralName = "ImageObjects";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.OWNER,
        ownerField: "owner",
        identityClaim: "cognito:username",
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE
        ]),
      AuthRule(
        authStrategy: AuthStrategy.PRIVATE,
        operations: [
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ImageObject.KEY,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ImageObject.URL,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ImageObject.POSTIMAGESID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _ImageObjectModelType extends ModelType<ImageObject> {
  const _ImageObjectModelType();
  
  @override
  ImageObject fromJson(Map<String, dynamic> jsonData) {
    return ImageObject.fromJson(jsonData);
  }
}