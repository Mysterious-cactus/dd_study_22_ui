import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_user_model.g.dart';

@JsonSerializable()
class CreateUserModel {
  @override
  final String name;
  final String email;
  final DateTime birthDate;
  final String password;
  final String retryPassword;

  CreateUserModel({
    required this.name,
    required this.email,
    required this.birthDate,
    required this.password,
    required this.retryPassword,
  });

  factory CreateUserModel.fromJson(Map<String, dynamic> json) =>
      _$CreateUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserModelToJson(this);

  factory CreateUserModel.fromMap(Map<String, dynamic> map) =>
      _$CreateUserModelFromJson(map);
  @override
  Map<String, dynamic> toMap() => _$CreateUserModelToJson(this);
}
