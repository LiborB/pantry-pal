// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_http.dart';

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

UpdateUserPayload _$UpdateUserPayloadFromJson(Map<String, dynamic> json) =>
    UpdateUserPayload(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      onboardedVersion: json['onboardedVersion'] as int,
    );

Map<String, dynamic> _$UpdateUserPayloadToJson(UpdateUserPayload instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'onboardedVersion': instance.onboardedVersion,
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

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      name: json['name'] as String,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'name': instance.name,
    };

UpdatePantryItem _$UpdatePantryItemFromJson(Map<String, dynamic> json) =>
    UpdatePantryItem(
      id: json['id'] as int,
      name: json['name'] as String,
      expiryDate:
          const CustomDateTimeConverter().fromJson(json['expiryDate'] as int),
      barcode: json['barcode'] as String,
      updateLocalItem: json['updateLocalItem'] as bool,
    );

Map<String, dynamic> _$UpdatePantryItemToJson(UpdatePantryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'expiryDate': const CustomDateTimeConverter().toJson(instance.expiryDate),
      'barcode': instance.barcode,
      'updateLocalItem': instance.updateLocalItem,
    };

PantryItem _$PantryItemFromJson(Map<String, dynamic> json) => PantryItem(
      id: json['id'] as int,
      name: json['name'] as String,
      expiryDate:
          const CustomDateTimeConverter().fromJson(json['expiryDate'] as int),
      createdAt:
          const CustomDateTimeConverter().fromJson(json['createdAt'] as int),
      barcode: json['barcode'] as String,
    );

Map<String, dynamic> _$PantryItemToJson(PantryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'expiryDate': const CustomDateTimeConverter().toJson(instance.expiryDate),
      'createdAt': const CustomDateTimeConverter().toJson(instance.createdAt),
      'barcode': instance.barcode,
    };

HouseholdMember _$HouseholdMemberFromJson(Map<String, dynamic> json) =>
    HouseholdMember(
      userId: json['userId'] as String,
      email: json['email'] as String,
      status: $enumDecode(_$MemberStatusEnumMap, json['status']),
      isOwner: json['isOwner'] as bool,
      createdAt:
          const CustomDateTimeConverter().fromJson(json['createdAt'] as int),
    );

Map<String, dynamic> _$HouseholdMemberToJson(HouseholdMember instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'isOwner': instance.isOwner,
      'status': _$MemberStatusEnumMap[instance.status]!,
      'createdAt': const CustomDateTimeConverter().toJson(instance.createdAt),
    };

const _$MemberStatusEnumMap = {
  MemberStatus.pending: 'pending',
  MemberStatus.accepted: 'accepted',
};

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

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _ApiHttp implements ApiHttp {
  _ApiHttp(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<Product> getProductInformation(
    String householdId,
    String barcode,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'barcode': barcode};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch<Map<String, dynamic>>(_setStreamType<Product>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/product/${householdId}/detail',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Product.fromJson(_result.data!);
    return value;
  }

  @override
  Future<dynamic> createPantryItem(
    String householdId,
    UpdatePantryItem item,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(item.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/pantry/${householdId}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> updatePantryItem(
    String householdId,
    UpdatePantryItem item,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(item.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/pantry/${householdId}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<List<PantryItem>> getPantryItems(String householdId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<List<dynamic>>(_setStreamType<List<PantryItem>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/pantry/${householdId}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => PantryItem.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<dynamic> createUser() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/user',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<AppUser> getUser() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch<Map<String, dynamic>>(_setStreamType<AppUser>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/user',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AppUser.fromJson(_result.data!);
    return value;
  }

  @override
  Future<dynamic> updateUser(UpdateUserPayload body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/user',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<List<HouseholdMember>> getHouseholdMembers(String householdId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<List<dynamic>>(_setStreamType<List<HouseholdMember>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/household/${householdId}/members',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => HouseholdMember.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<dynamic> addHouseholdMember(
    String householdId,
    AddMember body,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/household/${householdId}/members',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> createHousehold(CreateHouseholdPayload body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/household',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> updateHousehold(
    String householdId,
    UpdateHouseholdPayload body,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/household/${householdId}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<List<Household>> getHouseholds() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch<List<dynamic>>(_setStreamType<List<Household>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/household',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => Household.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
