import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String name;
  final String email;
  final String birthDate;
  final String avatarLink;
  //final int postCount;
  final String? region;
  final String? city;
  final List<String>? subscriptions;
  final List<String>? subscribers;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.birthDate,
    required this.avatarLink,
    //required this.postCount,
    required this.region,
    required this.city,
    required this.subscriptions,
    required this.subscribers,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
