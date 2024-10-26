import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:trader_app/core/network/api_client.dart';
import 'package:trader_app/core/network/exceptions/failure.dart';

class NewsRepository {
  Dio dio = ApiClient().dio;

  Future<Either<Failure, List>> fetchMarketNews(String category) async {
    try {
      var response =
          await dio.get('/news', queryParameters: {"category": category});
      return right(response.data);
    } on DioException catch (e) {
      return left(Failure(message: e.message ?? "Something went wrong"));
    }
  }
}
