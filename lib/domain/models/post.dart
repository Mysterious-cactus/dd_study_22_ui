import 'package:dd_study_22_ui/domain/db_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post implements DbModel {
  @override
  final String id;
  final String description;
  final String? authorId;
  final DateTime created;
  final int likeCount;
  final int commentCount;
  final int likedByMe;

  Post({
    required this.id,
    required this.description,
    this.authorId,
    required this.created,
    required this.likeCount,
    required this.commentCount,
    required this.likedByMe,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);

  factory Post.fromMap(Map<String, dynamic> map) => _$PostFromJson(map);
  @override
  Map<String, dynamic> toMap() => _$PostToJson(this);

  Post copyWith({
    String? id,
    String? description,
    String? authorId,
  }) {
    return Post(
        id: id ?? this.id,
        description: description ?? this.description,
        authorId: authorId ?? this.authorId,
        created: created,
        likeCount: likeCount,
        commentCount: commentCount,
        likedByMe: likedByMe);
  }
}
