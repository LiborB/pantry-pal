// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      onboardedVersion: json['onboardedVersion'] as int,
    );

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'onboardedVersion': instance.onboardedVersion,
    };

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) => UserSettings(
      userId: json['userId'] as String,
      notificationExpiryEnabled: json['notificationExpiryEnabled'] as bool,
    );

Map<String, dynamic> _$UserSettingsToJson(UserSettings instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'notificationExpiryEnabled': instance.notificationExpiryEnabled,
    };

UpdateUserPayload _$UpdateUserPayloadFromJson(Map<String, dynamic> json) =>
    UpdateUserPayload(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      onboardedVersion: json['onboardedVersion'] as int? ?? 1,
    );

Map<String, dynamic> _$UpdateUserPayloadToJson(UpdateUserPayload instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'onboardedVersion': instance.onboardedVersion,
    };
