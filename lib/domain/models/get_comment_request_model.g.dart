// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_comment_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCommentRequestModel _$GetCommentRequestModelFromJson(
        Map<String, dynamic> json) =>
    GetCommentRequestModel(
      id: json['id'] as String,
      commentText: json['commentText'] as String,
      created: DateTime.parse(json['created'] as String),
      author: User.fromJson(json['author'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetCommentRequestModelToJson(
        GetCommentRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'commentText': instance.commentText,
      'created': instance.created.toIso8601String(),
      'author': instance.author,
    };
