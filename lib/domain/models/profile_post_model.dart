import 'package:dd_study_22_ui/domain/models/get_comment_request_model.dart';
import 'package:dd_study_22_ui/domain/models/post_content.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_post_model.g.dart';

@JsonSerializable()
class ProfilePostModel {
  String id;
  String? description;
  List<PostContent> contents;
  List<GetCommentRequestModel>? comments;
  DateTime created;
  int likeCount;
  int commentCount;
  int likedByMe;

  ProfilePostModel({
    required this.id,
    this.description,
    required this.contents,
    required this.created,
    required this.likeCount,
    required this.commentCount,
    required this.likedByMe,
    this.comments,
  });

  factory ProfilePostModel.fromJson(Map<String, dynamic> json) =>
      _$ProfilePostModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfilePostModelToJson(this);
}
