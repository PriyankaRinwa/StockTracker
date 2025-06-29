class Stock {
  final String ticker;
  final double price;
  final double previousPrice;
  final bool isAnomalous;

  Stock({
    required this.ticker,
    required this.price,
    required this.previousPrice,
    this.isAnomalous = false,
  });

  Stock copyWith({
    double? price,
    double? previousPrice,
    bool? isAnomalous,
  }) {
    return Stock(
      ticker: ticker,
      price: price ?? this.price,
      previousPrice: previousPrice ?? this.previousPrice,
      isAnomalous: isAnomalous ?? this.isAnomalous,
    );
  }

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      ticker: json['ticker'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
      previousPrice: 0.0, // updated later
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Stock &&
              ticker == other.ticker &&
              price == other.price &&
              isAnomalous == other.isAnomalous;

  @override
  int get hashCode => ticker.hashCode ^ price.hashCode ^ isAnomalous.hashCode;

}
