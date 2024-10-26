import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:trader_app/core/network/interceptors/auth_interceptor.dart';

class ApiClient {
  static ApiClient? _instance;
  late Dio _dio;
  Dio get dio => _dio;
  // Private constructor
  ApiClient._internal() {
    _dio = Dio(BaseOptions(baseUrl: dotenv.env['BASE_URL'] ?? ""));
    _dio.interceptors.add(AuthInterceptor());
    _instance = this;
  }

  factory ApiClient() => _instance ?? ApiClient._internal();
  // Singleton instance
}
