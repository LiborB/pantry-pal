import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/http.dart';

part "api_http.g.dart";

@RestApi()
abstract class ApiHttp {
  factory ApiHttp(Dio dio, {String baseUrl}) = _ApiHttp;
  static Future<Dio> _getClient() async {
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();

    var dio = Dio(
      BaseOptions(
        baseUrl: dotenv.get("API_BASE_URL"),
        headers: {"Authorization": "Bearer $token"},
      ),
    );

    return dio;
  }

  static Future<T> get<T>(String url,
      {Map<String, dynamic>? queryParameters}) async {
    final client = await _getClient();

    final resp = await client.get<T>(url, queryParameters: queryParameters);

    final data = resp.data;

    if (data == null) {
      throw "Failed to parse response $resp";
    }

    return data;
  }

  static post(String url, Map<String, dynamic> body) async {
    final client = await _getClient();

    await client.post(url, data: body);
  }
}
