import 'package:get/get.dart';
import 'package:trader_app/core/models/stock_symbol.dart';
import 'package:trader_app/core/repositories/stock_repository.dart';

class SymbolSearchViewmodel extends GetxController {
  final StockRepository _stockRepository = StockRepository();

  List<StockSymbol> _symbols = [];
  List<StockSymbol> get symbols => _symbols;

  bool _loading = false;
  bool get loading => _loading;

  void handleSearchSymbol(String query) async {
    _loading = true;
    update();
    var response = await _stockRepository.searchSymbols(query);

    response.fold((l) {}, (data) {
      _symbols = data?['result']
          ?.map<StockSymbol>((symbol) => StockSymbol.fromMap(symbol))
          ?.toList();
    });
    _loading = false;
    update();
  }
}
