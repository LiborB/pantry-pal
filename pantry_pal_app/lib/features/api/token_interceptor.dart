import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      
      if (token == null) {
        return handler.reject(DioException(requestOptions: options, error: "No token"));
      }
      options.headers["authorization"] = "Bearer $token";
      return handler.next(options);
  }
}