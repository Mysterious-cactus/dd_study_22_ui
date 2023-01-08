import 'package:dd_study_22_ui/domain/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_comment_request_model.g.dart';

@JsonSerializable()
class GetCommentRequestModel {
  final String id;
  final String commentText;
  final DateTime created;
  final User author;
  List<String> likes = [];

  GetCommentRequestModel({
    required this.id,
    required this.commentText,
    required this.created,
    required this.author,
  });

  factory GetCommentRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GetCommentRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetCommentRequestModelToJson(this);
}
