// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'household.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateHouseholdPayload _$UpdateHouseholdPayloadFromJson(
        Map<String, dynamic> json) =>
    UpdateHouseholdPayload(
      name: json['name'] as String,
    );

Map<String, dynamic> _$UpdateHouseholdPayloadToJson(
        UpdateHouseholdPayload instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

Household _$HouseholdFromJson(Map<String, dynamic> json) => Household(
      id: json['id'] as int,
      name: json['name'] as String,
      createdAt:
          const CustomDateTimeConverter().fromJson(json['createdAt'] as int),
    );

Map<String, dynamic> _$HouseholdToJson(Household instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': const CustomDateTimeConverter().toJson(instance.createdAt),
    };

CreateHouseholdPayload _$CreateHouseholdPayloadFromJson(
        Map<String, dynamic> json) =>
    CreateHouseholdPayload(
      name: json['name'] as String,
    );

Map<String, dynamic> _$CreateHouseholdPayloadToJson(
        CreateHouseholdPayload instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

AddMember _$AddMemberFromJson(Map<String, dynamic> json) => AddMember(
      email: json['email'] as String,
    );

Map<String, dynamic> _$AddMemberToJson(AddMember instance) => <String, dynamic>{
      'email': instance.email,
    };

HouseholdMember _$HouseholdMemberFromJson(Map<String, dynamic> json) =>
    HouseholdMember(
      userId: json['userId'] as String,
      email: json['email'] as String,
      status: $enumDecode(_$MemberStatusEnumMap, json['status']),
      isOwner: json['isOwner'] as bool,
      createdAt:
          const CustomDateTimeConverter().fromJson(json['createdAt'] as int),
      householdId: json['householdId'] as int,
    );

Map<String, dynamic> _$HouseholdMemberToJson(HouseholdMember instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'isOwner': instance.isOwner,
      'status': _$MemberStatusEnumMap[instance.status]!,
      'createdAt': const CustomDateTimeConverter().toJson(instance.createdAt),
      'householdId': instance.householdId,
    };

const _$MemberStatusEnumMap = {
  MemberStatus.pending: 'pending',
  MemberStatus.accepted: 'accepted',
};
