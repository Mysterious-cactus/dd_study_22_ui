import 'package:dd_study_22_ui/domain/models/attach_meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_post_request.g.dart';

@JsonSerializable()
class CreatePostRequest {
  String authorId;
  String? description;
  List<AttachMeta> contents;

  CreatePostRequest({
    required this.authorId,
    this.description,
    required this.contents,
  });

  factory CreatePostRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePostRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePostRequestToJson(this);
}
