

import 'package:json_annotation/json_annotation.dart';

import '../converter.dart';

part 'household.g.dart';

@JsonSerializable()
class UpdateHouseholdPayload {
  String name;

  UpdateHouseholdPayload({required this.name});

  toJson() => _$UpdateHouseholdPayloadToJson(this);
}

@JsonSerializable()
@CustomDateTimeConverter()
class Household {
  int id;
  String name;
  DateTime createdAt;

  Household({required this.id, required this.name, required this.createdAt});

  factory Household.fromJson(Map<String, dynamic> json) =>
      _$HouseholdFromJson(json);
}

@JsonSerializable()
class CreateHouseholdPayload {
  String name;

  CreateHouseholdPayload({required this.name});

  toJson() => _$CreateHouseholdPayloadToJson(this);
}

@JsonSerializable()
class AddMember {
  String email;

  AddMember({required this.email});

  toJson() => _$AddMemberToJson(this);
}



enum MemberStatus {
  pending,
  accepted,
}

@JsonSerializable()
@CustomDateTimeConverter()
class HouseholdMember {
  String userId;
  String email;
  bool isOwner;
  MemberStatus status;
  DateTime createdAt;
  int householdId;

  HouseholdMember({
    required this.userId,
    required this.email,
    required this.status,
    required this.isOwner,
    required this.createdAt,
    required this.householdId,
  });

  factory HouseholdMember.fromJson(Map<String, dynamic> json) =>
      _$HouseholdMemberFromJson(json);

  toJson() => _$HouseholdMemberToJson(this);
}