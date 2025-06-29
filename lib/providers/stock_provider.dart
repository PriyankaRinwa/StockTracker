import 'package:flutter/material.dart';
import '../models/stock_model.dart';
import '../services/web_socket_service.dart';
import '../utils/enums.dart';

class StockProvider with ChangeNotifier {
  final WebSocketService _service = WebSocketService();

  List<Stock> _stocks = [];
  ConnectionStatus _status = ConnectionStatus.connecting;

  List<Stock> get stocks => _stocks;
  ConnectionStatus get status => _status;

  /// Called during app startup
  void init() {
    _service.stockStream.listen((data) {
      _updateStocks(data);
    });

    _service.statusStream.listen((status) {
      if (_status != status) {
        _status = status;
        notifyListeners(); // only notify if changed
      }
    });

    _service.connect();
  }

  /// Dispose socket service
  void disposeService() {
    _service.dispose();
  }

  /// update stocks without triggering unnecessary rebuilds
  void _updateStocks(List<Stock> newList) {
    if (_stocks.length != newList.length ||
        !_areStocksEqual(_stocks, newList)) {
      _stocks = newList;
      notifyListeners();
    }
  }

  /// equality check
  bool _areStocksEqual(List<Stock> a, List<Stock> b) {
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Stock getStockByTicker(String ticker) =>
      _stocks.firstWhere((s) => s.ticker == ticker, orElse: () => Stock(ticker: ticker, price: 0.0, previousPrice: 0.0));

}
