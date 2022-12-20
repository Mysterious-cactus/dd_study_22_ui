// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePostRequest _$CreatePostRequestFromJson(Map<String, dynamic> json) =>
    CreatePostRequest(
      authorId: json['authorId'] as String,
      description: json['description'] as String?,
      contents: (json['contents'] as List<dynamic>)
          .map((e) => AttachMeta.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreatePostRequestToJson(CreatePostRequest instance) =>
    <String, dynamic>{
      'authorId': instance.authorId,
      'description': instance.description,
      'contents': instance.contents,
    };
