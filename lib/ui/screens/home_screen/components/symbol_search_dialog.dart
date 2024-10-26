import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trader_app/constants/color_palate.dart';
import 'package:trader_app/core/models/stock_symbol.dart';
import 'package:trader_app/core/view_models/symbol_search_viewmodel.dart';
import 'package:trader_app/ui/screens/widgets/loading.dart';
import 'package:trader_app/utils/debouncer.dart';

class SymbolSearchDialog extends StatelessWidget {
  SymbolSearchDialog({super.key});

  final TextEditingController textEditingController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 700);
  final controller = Get.put(SymbolSearchViewmodel());

  onTextChange(String text) {
    _debouncer.run(() {
      if (text.isNotEmpty) {
        controller.handleSearchSymbol(text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close_rounded),
                  ),
                  Expanded(
                      child: CupertinoSearchTextField(
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    controller: textEditingController,
                    placeholder: "Search Stocks",
                    style: const TextStyle(color: Colors.white),
                    onChanged: onTextChange,
                  ))
                ],
              ),
              const SizedBox(height: 20),
              GetBuilder<SymbolSearchViewmodel>(
                dispose: (state) {
                  Get.delete<SymbolSearchViewmodel>();
                },
                builder: (controller) {
                  if (controller.loading) {
                    return const Loader();
                  }
                  if (textEditingController.text.isNotEmpty &&
                      controller.symbols.isEmpty) {
                    return const Center(child: Text('No data found'));
                  }

                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        StockSymbol stockSymbol = controller.symbols[index];

                        return ListTile(
                          title: Text(
                            stockSymbol.displaySymbol,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          trailing: Text(
                            stockSymbol.type ?? "",
                          ),
                          subtitle: Text(
                            stockSymbol.description ?? "",
                            style: const TextStyle(
                                fontSize: 13, color: ColorPalate.gray),
                          ),
                        );
                      },
                      itemCount: controller.symbols.length,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
