import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:trader_app/constants/enums.dart';
import 'package:trader_app/core/network/api_client.dart';
import 'package:trader_app/core/network/exceptions/failure.dart';

class StockRepository {
  Dio dio = ApiClient().dio;

  Future<Either<Failure, dynamic>> getAssetSymbols(AssetType assetType) async {
    try {
      final response = await dio
          .get('/${assetType.name}/symbol?exchange=${assetType.exchange}');
      return right(response.data);
    } on DioException catch (e) {
      return left(Failure(message: e.message));
    }
  }
  Future<Either<Failure, dynamic>> searchSymbols(String query) async {
    try {
      final response = await dio
          .get('/search?q=$query&exchange=US');
      return right(response.data);
    } on DioException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  Future<Either<Failure, dynamic>> getSymbolQuote(String symbol) async {
    try {
      final response = await dio.get('/quote?symbol=$symbol');
      return right(response.data);
    } on DioException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  Future<Either<Failure, dynamic>> getCompanyProfile(String symbol) async {
    try {
      final response = await dio.get('/stock/profile2?symbol=$symbol');
      return right(response.data);
    } on DioException catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
