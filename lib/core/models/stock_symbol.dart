// ignore_for_file: public_member_api_docs, sort_constructors_first

class StockSymbol {
  String symbol;
  String displaySymbol;
  String? type;
  String? description;
  StockSymbol({
    required this.symbol,
    required this.displaySymbol,
    this.type,
    this.description,
  });

  factory StockSymbol.fromMap(Map<String, dynamic> map) {
    return StockSymbol(
      symbol: map['symbol'] as String,
      displaySymbol: map['displaySymbol'] as String,
      type: map['type'] != null ? map['type'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
    );
  }
}
