import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class AppUser {
  String id;
  String email;
  String firstName;
  String lastName;
  int onboardedVersion;

  AppUser(
      {required this.id,
        required this.email,
        required this.firstName,
        required this.lastName,
        required this.onboardedVersion});

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  toJson() => _$AppUserToJson(this);
}

@JsonSerializable()
class UserSettings {
  String userId;
  bool notificationExpiryEnabled;

  UserSettings({required this.userId, required this.notificationExpiryEnabled});

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);

  toJson() => _$UserSettingsToJson(this);

  UserSettings copyWith({bool? notificationExpiryEnabled}) {
    return UserSettings(
      userId: userId,
      notificationExpiryEnabled: notificationExpiryEnabled ?? this.notificationExpiryEnabled,
    );
  }
}

@JsonSerializable()
class UpdateUserPayload {
  String firstName;
  String lastName;
  int onboardedVersion;

  UpdateUserPayload(
      {required this.firstName,
        required this.lastName,
        this.onboardedVersion = 1});

  toJson() => _$UpdateUserPayloadToJson(this);
}