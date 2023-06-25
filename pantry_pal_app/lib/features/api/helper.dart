import 'package:dio/dio.dart';

String unwrapErrorResponse(dynamic err) {
  if (err is DioException && err.response?.data["code"] != null) {
    return err.response!.data["code"];
  } else {
    return "Unknown error occurred";
  }
}