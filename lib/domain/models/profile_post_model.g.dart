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
      likeCount: json['likeCount'] as int,
      commentCount: json['commentCount'] as int,
      likedByMe: json['likedByMe'] as int,
      comments: (json['comments'] as List<dynamic>?)
          ?.map(
              (e) => GetCommentRequestModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProfilePostModelToJson(ProfilePostModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'contents': instance.contents,
      'comments': instance.comments,
      'created': instance.created.toIso8601String(),
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'likedByMe': instance.likedByMe,
    };
