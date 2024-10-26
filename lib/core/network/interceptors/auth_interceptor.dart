import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/route_manager.dart';
import 'package:trader_app/utils/app_snakbar.dart';

class AuthInterceptor implements InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({"token": dotenv.env['TOKEN']});
    handler.next(options);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    if (error.response?.statusCode == 403) {
      return handler.reject(DioException(
          requestOptions: error.requestOptions,
          message: "You don't have access to this resource."));
    } else if (error.response?.statusCode == 401) {
      return handler.reject(DioException(
          requestOptions: error.requestOptions, message: "Unauthorized"));
    } else if (error.response?.statusCode == 429) {
      if (!Get.isSnackbarOpen) {
        AppSnakbar.error('Too many requests, try again later');
      }
      return handler.reject(DioException(
          requestOptions: error.requestOptions,
          message: "Too many requests, try again later"));
    }
    handler.next(error);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }
}
