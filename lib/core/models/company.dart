class Company {
  String logo;
  String ticker;
  String name;
  double marketCapitalization;
  Company({
    required this.logo,
    required this.ticker,
    required this.name,
    required this.marketCapitalization,
  });

  Company copyWith({
    String? logo,
    String? ticker,
    String? name,
    double? marketCapitalization,
  }) {
    return Company(
      logo: logo ?? this.logo,
      ticker: ticker ?? this.ticker,
      name: name ?? this.name,
      marketCapitalization: marketCapitalization ?? this.marketCapitalization,
    );
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      logo: map['logo'] ?? '',
      ticker: map['ticker'] ?? '',
      name: map['name'] ?? '',
      marketCapitalization: map['marketCapitalization']?.toDouble() ?? 0.0,
    );
  }

  @override
  String toString() {
    return 'Company(logo: $logo, ticker: $ticker, name: $name, marketCapitalization: $marketCapitalization)';
  }
}
