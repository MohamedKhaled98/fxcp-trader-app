import 'dart:math';

import 'package:get/get.dart';
import 'package:trader_app/core/models/news.dart';
import 'package:trader_app/core/repositories/news_repository.dart';
import 'package:trader_app/utils/app_snakbar.dart';

class NewsViewmodel extends GetxController {
  final NewsRepository _newsRepository = NewsRepository();

  bool _loading = false;
  bool get loading => _loading;

  List<News> _marketNews = [];
  List<News> get marketNews => _marketNews;

  String category = 'general';

  @override
  void onInit() {
    super.onInit();
    fetchMarketNews();
  }

  void handleChangeCategory(String updatedCategory) {
    category = updatedCategory;
    fetchMarketNews();
  }

  void fetchMarketNews() async {
    _loading = true;
    update();
    var response = await _newsRepository.fetchMarketNews(category);
    response.fold((l) => AppSnakbar.error(l.message), (data) {
      int maxItems = min(data.length, 10);
      _marketNews = data
          .getRange(0, maxItems)
          .map<News>((news) => News.fromMap(news))
          .toList();
    });
    _loading = false;
    update();
  }
}
