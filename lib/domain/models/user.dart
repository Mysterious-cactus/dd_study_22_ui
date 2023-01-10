import 'package:json_annotation/json_annotation.dart';
import 'package:dd_study_22_ui/domain/db_model.dart';

part 'user.g.dart';

@JsonSerializable()
class User implements DbModel {
  @override
  final String id;
  final String name;
  final String email;
  final DateTime birthDate;
  final String? avatarLink;
  //final int postCount;
  final String? region;
  final String? city;
  //final List<ProfilePostModel>? posts;
  List<String>? subscriptions;
  List<String>? subscribers;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.birthDate,
    this.avatarLink,
    //required this.postCount,
    this.region,
    this.city,
    //this.posts
    this.subscriptions,
    this.subscribers,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromMap(Map<String, dynamic> map) => _$UserFromJson(map);
  @override
  Map<String, dynamic> toMap() => _$UserToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.birthDate == birthDate &&
        other.avatarLink == avatarLink &&
        other.region == region &&
        other.city == city &&
        other.subscribers == subscribers &&
        other.subscriptions == subscriptions;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        birthDate.hashCode ^
        avatarLink.hashCode ^
        region.hashCode ^
        city.hashCode ^
        subscribers.hashCode ^
        subscriptions.hashCode;
  }
}
