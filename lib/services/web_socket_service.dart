import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/stock_model.dart';
import '../utils/enums.dart';


class WebSocketService {
  final _controller = StreamController<List<Stock>>.broadcast();
  final _statusController = StreamController<ConnectionStatus>.broadcast();

  Stream<List<Stock>> get stockStream => _controller.stream;
  Stream<ConnectionStatus> get statusStream => _statusController.stream;

  WebSocketChannel? _channel;
  Timer? _reconnectTimer;

  final Map<String, Stock> _stockMap = {};
  bool _isReconnecting = false;
  int _backoffDelay = 2;
  final int _maxBackoff = 30;
  ConnectionStatus _currentStatus = ConnectionStatus.disconnected;

  /// Establishes a WebSocket connection and sets up listeners for incoming data,
  void connect() {
    _updateStatus(ConnectionStatus.connecting);
    _channel = WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:8080/ws'));

    _updateStatus(ConnectionStatus.connected);
    _backoffDelay = 2; // Reset delay when connected


    _channel!.stream.listen((data) {
      try {
        final parsed = jsonDecode(data);
        if (parsed is! List) throw FormatException('Expected list');

        keepOldPrice(parsed);

      } catch (e) {
        debugPrint('[Warning] Malformed WebSocket message ignored: $e');
      }
    }, onDone: _reconnect, onError: (e) {
      debugPrint('Error: $e');
      _reconnect();
    });
  }

  /// Processes incoming stock data, detects anomalies (e.g., price drops > 90%),
  /// preserves the last valid price for anomalous entries, and updates the stock list.
  void keepOldPrice(parsed){
    final List<Stock> newList = [];
    for (var item in parsed) {
      final incoming = Stock.fromJson(item);
      final previous = _stockMap[incoming.ticker];

      bool isAnomaly = false;

      if (previous != null) {
        final dropPercent = ((previous.price - incoming.price) / previous.price) * 100;

        if (dropPercent > 90) {
          isAnomaly = true;
        }
      }

      final updated = Stock(
        ticker: incoming.ticker,
        price: isAnomaly ? (previous?.price ?? incoming.price) : incoming.price,
        previousPrice: previous?.price ?? incoming.price,
        isAnomalous: isAnomaly,
      );

      _stockMap[incoming.ticker] = updated;
      newList.add(updated);
    }

    _controller.add(newList);
  }


  /// dispose channel and change status
  void dispose() {
    _updateStatus(ConnectionStatus.disconnected);
    _channel?.sink.close();
    _controller.close();
    _statusController.close();
  }


  /// Attempts to reconnect to the WebSocket server using exponential backoff.
  /// This function is triggered when a disconnection or error occurs.
  /// Ensures that only one reconnection attempt runs at a time.
  void _reconnect() {
    if (_isReconnecting) return;
    _isReconnecting = true;

    _updateStatus(ConnectionStatus.reconnecting);
    _channel?.sink.close();

    _reconnectTimer = Timer(Duration(seconds: _backoffDelay), () {
      connect();
      _isReconnecting = false;
      _backoffDelay = (_backoffDelay * 2).clamp(2, _maxBackoff);
    });
  }

  /// Updates the connection status
  void _updateStatus(ConnectionStatus newStatus) {
    if (_currentStatus != newStatus) {
      _currentStatus = newStatus;
      _statusController.add(newStatus);
    }
  }


}
