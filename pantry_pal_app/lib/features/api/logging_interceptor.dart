import 'package:dio/dio.dart';
import 'package:pantry_pal/shared/logger.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    logger.info({
      "message": "Request to api",
      "method": options.method,
      "url": options.uri.toString(),
      "data": options.data,
    });
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    logger.info({
      "url": response.requestOptions.uri.toString(),
      "message": "Response from api",
      "statusCode": response.statusCode,
      "statusMessage": response.statusMessage,
      "data": response.data,
    });
    return handler.next(response);
  }
}
