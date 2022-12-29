// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfilePostModel _$ProfilePostModelFromJson(Map<String, dynamic> json) =>
    ProfilePostModel(
      id: json['id'] as String,
      description: json['description'] as String?,
      contents: (json['contents'] as List<dynamic>)
          .map((e) => PostContent.fromJson(e as Map<String, dynamic>))
          .toList(),
      created: DateTime.parse(json['created'] as String),
    );

Map<String, dynamic> _$ProfilePostModelToJson(ProfilePostModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'contents': instance.contents,
      'created': instance.created.toIso8601String(),
    };
