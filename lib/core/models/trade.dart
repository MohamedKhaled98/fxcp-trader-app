import 'dart:convert';

class Trade {
  final String symbol;
  final double price;
  final double closePrice;
  final String? displaySymbol;
  final int? volume;
  final DateTime? timestamp;

  Trade({
    required this.symbol,
    required this.price,
    required this.closePrice,
    this.displaySymbol,
    this.volume,
    this.timestamp,
  });
  Trade copyWith({
    String? symbol,
    double? price,
    double? closePrice,
    String? displaySymbol,
    int? volume,
    DateTime? timestamp,
  }) {
    return Trade(
      symbol: symbol ?? this.symbol,
      price: price ?? this.price,
      closePrice: closePrice ?? this.closePrice,
      displaySymbol: displaySymbol ?? this.displaySymbol,
      volume: volume ?? this.volume,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'symbol': symbol});
    result.addAll({'price': price});
    result.addAll({'displaySymbol': displaySymbol});
    result.addAll({'closePrice': closePrice});
    if (volume != null) {
      result.addAll({'volume': volume});
    }
    if (timestamp != null) {
      result.addAll({'timestamp': timestamp!.millisecondsSinceEpoch});
    }

    return result;
  }

  factory Trade.fromMap(Map<String, dynamic> map) {
    return Trade(
      symbol: map['symbol'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      closePrice: map['closePrice']?.toDouble() ?? 0.0,
      displaySymbol: map['displaySymbol'] ?? '',
      volume: map['volume']?.toInt(),
      timestamp: map['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Trade.fromJson(String source) => Trade.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Trade(symbol: $symbol, displaySymbol: $displaySymbol, price: $price, volume: $volume, timestamp: $timestamp, closePrice: $closePrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Trade &&
        other.symbol == symbol &&
        other.price == price &&
        other.displaySymbol == displaySymbol &&
        other.volume == volume &&
        other.timestamp == timestamp &&
        other.closePrice == closePrice;
  }

  @override
  int get hashCode {
    return symbol.hashCode ^
        displaySymbol.hashCode ^
        price.hashCode ^
        volume.hashCode ^
        timestamp.hashCode ^
        closePrice.hashCode;
  }
}
