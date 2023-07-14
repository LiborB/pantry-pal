import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pantry_pal/features/api/logging_interceptor.dart';
import 'package:pantry_pal/features/api/token_interceptor.dart';
import 'package:pantry_pal/shared/environment.dart' as env;
import 'package:retrofit/http.dart';

import 'converter.dart';
import 'models/household.dart';
import 'models/pantry.dart';
import 'models/user.dart';

part "api_http.g.dart";

@RestApi()
abstract class ApiHttp {
  factory ApiHttp() {
    var dio = Dio();

    dio.interceptors.add(TokenInterceptor());
    dio.interceptors.add(LoggingInterceptor());

    return _ApiHttp(dio, baseUrl: env.apiBaseUrl);
  }

  @POST("/product/{householdId}/detail")
  Future<Product> getProductInformation(
      @Path() String householdId, @Query("barcode") String barcode);

  @POST("/pantry/{householdId}")
  Future createPantryItem(
      @Path() String householdId, @Body() UpdatePantryItem item);

  @POST("/pantry/{householdId}/update")
  Future updatePantryItem(
      @Path() String householdId, @Body() UpdatePantryItem item);

  @GET("/pantry/{householdId}")
  Future<List<PantryItem>> getPantryItems(@Path() String householdId);

  @POST("/user")
  Future createUser();

  @GET("/user")
  Future<AppUser> getUser();

  @POST("/user/update")
  Future updateUser(@Body() UpdateUserPayload body);

  @GET("/user/settings")
  Future<UserSettings> getUserSettings();

  @POST("/user/settings/update")
  Future updateUserSettings(@Body() UserSettings body);

  @GET("/household/{householdId}/members")
  Future<List<HouseholdMember>> getHouseholdMembers(@Path() String householdId);

  @POST("/household/{householdId}/members")
  Future addHouseholdMember(@Path() String householdId, @Body() AddMember body);

  @GET("/household/invites")
  Future<List<HouseholdMember>> getPendingInvites();

  @POST("/household/invites/respond")
  Future respondInvite(@Query("householdId") String householdId, @Query("accept") bool accept);

  @POST("/household")
  Future createHousehold(@Body() CreateHouseholdPayload body);

  @POST("/household/{householdId}")
  Future updateHousehold(
      @Path() String householdId, @Body() UpdateHouseholdPayload body);

  @GET("/household")
  Future<List<Household>> getHouseholds();
}
