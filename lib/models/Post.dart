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

import 'ModelProvider.dart';
import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Post type in your schema. */
@immutable
class Post extends Model {
  static const classType = const _PostModelType();
  final String id;
  final String? _caption;
  final List<ImageObject>? _images;
  final User? _user;
  final List<Comment>? _comments;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String get caption {
    try {
      return _caption!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  List<ImageObject> get images {
    try {
      return _images!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  User? get user {
    return _user;
  }
  
  List<Comment>? get comments {
    return _comments;
  }
  
  const Post._internal({required this.id, required caption, required images, user, comments}): _caption = caption, _images = images, _user = user, _comments = comments;
  
  factory Post({String? id, required String caption, required List<ImageObject> images, User? user, List<Comment>? comments}) {
    return Post._internal(
      id: id == null ? UUID.getUUID() : id,
      caption: caption,
      images: images != null ? List<ImageObject>.unmodifiable(images) : images,
      user: user,
      comments: comments != null ? List<Comment>.unmodifiable(comments) : comments);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Post &&
      id == other.id &&
      _caption == other._caption &&
      DeepCollectionEquality().equals(_images, other._images) &&
      _user == other._user &&
      DeepCollectionEquality().equals(_comments, other._comments);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Post {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("caption=" + "$_caption" + ", ");
    buffer.write("user=" + (_user != null ? _user!.toString() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Post copyWith({String? id, String? caption, List<ImageObject>? images, User? user, List<Comment>? comments}) {
    return Post(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      images: images ?? this.images,
      user: user ?? this.user,
      comments: comments ?? this.comments);
  }
  
  Post.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _caption = json['caption'],
      _images = json['images'] is List
        ? (json['images'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => ImageObject.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _user = json['user']?['serializedData'] != null
        ? User.fromJson(new Map<String, dynamic>.from(json['user']['serializedData']))
        : null,
      _comments = json['comments'] is List
        ? (json['comments'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => Comment.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'caption': _caption, 'images': _images?.map((e) => e?.toJson())?.toList(), 'user': _user?.toJson(), 'comments': _comments?.map((e) => e?.toJson())?.toList()
  };

  static final QueryField ID = QueryField(fieldName: "post.id");
  static final QueryField CAPTION = QueryField(fieldName: "caption");
  static final QueryField IMAGES = QueryField(
    fieldName: "images",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (ImageObject).toString()));
  static final QueryField USER = QueryField(
    fieldName: "user",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (User).toString()));
  static final QueryField COMMENTS = QueryField(
    fieldName: "comments",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (Comment).toString()));
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Post";
    modelSchemaDefinition.pluralName = "Posts";
    
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
      key: Post.CAPTION,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
      key: Post.IMAGES,
      isRequired: false,
      ofModelName: (ImageObject).toString(),
      associatedKey: ImageObject.POSTIMAGESID
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.belongsTo(
      key: Post.USER,
      isRequired: false,
      targetName: "userID",
      ofModelName: (User).toString()
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
      key: Post.COMMENTS,
      isRequired: false,
      ofModelName: (Comment).toString(),
      associatedKey: Comment.POST
    ));
  });
}

class _PostModelType extends ModelType<Post> {
  const _PostModelType();
  
  @override
  Post fromJson(Map<String, dynamic> jsonData) {
    return Post.fromJson(jsonData);
  }
}