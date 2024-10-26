enum AssetType {
  stock('Stocks', 'US', ['AAPL', 'AMZN', 'MSFT', 'TSLA', 'GOOGL']),
  crypto('Crypto', 'BINANCE', [
    'BINANCE:BTCUSDT',
    'BINANCE:ETHUSDT',
    'BINANCE:BNBUSDT',
    'BINANCE:SOLUSDT',
  ]);

  final String title;
  final String exchange;
  final List<String> popularSymbols;

  const AssetType(this.title, this.exchange, this.popularSymbols);
}
