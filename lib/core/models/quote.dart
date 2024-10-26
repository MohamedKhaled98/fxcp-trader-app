class Quote {
  final double currentPrice; 
  final double previousClose;
  Quote({
    required this.currentPrice,
    required this.previousClose,
  });

  Quote copyWith({
    double? currentPrice,
    double? previousClose,
  }) {
    return Quote(
      currentPrice: currentPrice ?? this.currentPrice,
      previousClose: previousClose ?? this.previousClose,
    );
  }

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      currentPrice: map['c']?.toDouble() ?? 0.0,
      previousClose: map['pc']?.toDouble() ?? 0.0,
    );
  }
}
