// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      avatarLink: json['avatarLink'] as String?,
      region: json['region'] as String?,
      city: json['city'] as String?,
      subscriptions: (json['subscriptions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      subscribers: (json['subscribers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'birthDate': instance.birthDate.toIso8601String(),
      'avatarLink': instance.avatarLink,
      'region': instance.region,
      'city': instance.city,
      'subscriptions': instance.subscriptions,
      'subscribers': instance.subscribers,
    };
