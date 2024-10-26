import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:trader_app/constants/color_palate.dart';
import 'package:trader_app/core/models/news.dart';
import 'package:trader_app/core/view_models/news_viewmodel.dart';
import 'package:trader_app/ui/screens/widgets/loading.dart';

const List<String> categories = ['general', 'forex', 'crypto', 'merger'];

class NewsScreen extends StatelessWidget {
  NewsScreen({super.key});

  final NewsViewmodel controller = Get.put(NewsViewmodel());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market News'),
        actions: [
          PullDownButton(
            itemBuilder: (context) => categories
                .map<PullDownMenuItem>(
                  (category) => PullDownMenuItem.selectable(
                    title: category.toUpperCase(),
                    selected: controller.category == category,
                    onTap: () {
                      controller.handleChangeCategory(category);
                    },
                  ),
                )
                .toList(),
            buttonBuilder: (context, showMenu) => CupertinoButton(
              onPressed: showMenu,
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.ellipsis_circle),
            ),
          )
        ],
      ),
      body: Scaffold(
        body: GetBuilder<NewsViewmodel>(
          builder: (controller) {
            if (controller.loading) {
              return const Loader();
            }

            return ListView.separated(
              padding: const EdgeInsets.all(15),
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                News news = controller.marketNews[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: ColorPalate.forground.withOpacity(0.5),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          news.category.toLowerCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: ColorPalate.gray),
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            news.image,
                            height: 100,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          news.headline,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          news.source,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: ColorPalate.primary),
                        ),
                        Text(
                          Jiffy.parseFromMillisecondsSinceEpoch(
                                  news.datetime * 1000)
                              .yMMMMd,
                          style: const TextStyle(color: ColorPalate.gray),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: controller.marketNews.length,
            );
          },
        ),
      ),
    );
  }
}
