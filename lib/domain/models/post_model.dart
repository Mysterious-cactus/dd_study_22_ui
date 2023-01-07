import 'package:dd_study_22_ui/domain/models/get_comment_request_model.dart';
import 'package:dd_study_22_ui/domain/models/post_content.dart';
import 'package:dd_study_22_ui/domain/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  String id;
  String? description;
  User author;
  List<PostContent> contents;
  List<GetCommentRequestModel>? comments;
  DateTime created;

  PostModel({
    required this.id,
    this.description,
    required this.author,
    required this.contents,
    required this.created,
    this.comments,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}
