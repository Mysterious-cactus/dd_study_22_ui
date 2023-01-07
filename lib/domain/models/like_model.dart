import 'package:json_annotation/json_annotation.dart';

part 'like_model.g.dart';

@JsonSerializable()
class LikeModel {
  final String entityId;
  final String authorId;

  LikeModel({
    required this.entityId,
    required this.authorId,
  });

  factory LikeModel.fromJson(Map<String, dynamic> json) =>
      _$LikeModelFromJson(json);

  Map<String, dynamic> toJson() => _$LikeModelToJson(this);
}
