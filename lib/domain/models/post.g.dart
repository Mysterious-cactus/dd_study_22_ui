// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as String,
      description: json['description'] as String,
      authorId: json['authorId'] as String?,
      created: DateTime.parse(json['created'] as String),
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'authorId': instance.authorId,
      'created': instance.created.toIso8601String(),
    };
