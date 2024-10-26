import 'package:get/state_manager.dart';
import 'package:trader_app/constants/enums.dart';
import 'package:trader_app/core/models/company.dart';
import 'package:trader_app/core/models/quote.dart';
import 'package:trader_app/core/models/top_mover.dart';
import 'package:trader_app/core/network/sockets/finnhub_websocket.dart';
import 'package:trader_app/core/repositories/stock_repository.dart';

import 'package:trader_app/core/models/trade.dart';

class HomeViewModel extends GetxController {
  final StockRepository _stockRepository =
      StockRepository(); // it can be a singlton for cashing but in this case we don't
  final FinnhubWebSocket _socket = FinnhubWebSocket();

  AssetType assetType = AssetType.stock;
  List<String> _symbols = AssetType.stock.popularSymbols;

  bool topMoversLoading = true;
  List<TopMover> _topMovers = [];
  List<TopMover> get topMovers => _topMovers;

  bool liveTradesLoading = true;
  Map<String, Trade> _liveTrades = {};
  List<Trade> get liveTrades => _liveTrades.values.toList();

  @override
  void onInit() {
    super.onInit();
    _socket.connect(_handleRecivedData, initialSymbols: _symbols);
    handleFetchTopMovers();
    getInitialSymbolsPrices();
  }

  handleChangeAssetType(AssetType type) {
    if (type == assetType) return;
    assetType = type;
    update(['asset_type_tabs']);

    liveTradesLoading = true;
    _liveTrades.clear();
    update(['live_trades']);

    _symbols = type.popularSymbols;
    getInitialSymbolsPrices();
    _socket.changeSubscriptions(_symbols);
  }

  void handleFetchTopMovers() async {
    List<TopMover> topMovers = [];

    final futures = AssetType.stock.popularSymbols.map((symbol) async {
      final quoteResponse = await _stockRepository.getSymbolQuote(symbol);
      final profileResponse = await _stockRepository.getCompanyProfile(symbol);

      if (quoteResponse.isRight() && profileResponse.isRight()) {
        final quote = quoteResponse.getOrElse(() => null);
        final company = profileResponse.getOrElse(() => null);

        if (quote != null && company != null) {
          topMovers.add(TopMover(
            company: Company.fromMap(company),
            quote: Quote.fromMap(quote),
          ));
        }
      }
    });

    await Future.wait(futures);
    _topMovers = topMovers;
    topMoversLoading = false;
    update(['top_movers']);
  }

  void getInitialSymbolsPrices() async {
    Map<String, Trade> trades = {};
    final futures = _symbols.map((symbol) async {
      final response = await _stockRepository.getSymbolQuote(symbol);
      response.fold((l) {}, (data) {
        double price = data['c']?.toDouble();
        double closePrice = data['pc']?.toDouble();
        trades[symbol] =
            Trade(symbol: symbol, price: price, closePrice: closePrice);
      });
    }).toList();
    await Future.wait(futures);
    _liveTrades = trades;
    update(['live_trades']);

    liveTradesLoading = false;
  }

  _handleRecivedData(Map message) {
    if (message['type'] == 'trade') {
      for (var stoke in message['data']) {
        String symbol = stoke['s'];
        if (_liveTrades.containsKey(symbol)) {
          double currentPrice = stoke['p']?.toDouble();
          _liveTrades[symbol] = Trade(
              symbol: symbol,
              price: currentPrice,
              closePrice: _liveTrades[symbol]?.closePrice ?? currentPrice);
        }
      }
    }
    update(['live_trades']);
  }
}
