import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/stock_model.dart';
import '../../providers/stock_provider.dart';
import '../widgets/connection_indicator.dart';
import '../widgets/stock_tile.dart';

class StockTrackerScreen extends StatelessWidget {
  const StockTrackerScreen({super.key});

  /// A UI screen that displays the current stock prices,
  /// updates in real-time via WebSocket
  /// This screen uses `Provider` for state management to listen Stock provider
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StockProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Tracker'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ConnectionIndicator(status: provider.status),
          ),
        ],
      ),

      body: ListView.builder(
        itemCount: provider.stocks.length,
        itemBuilder: (context, index) {
          final ticker = provider.stocks[index].ticker;

          return Selector<StockProvider, Stock>(
            selector: (_, provider) => provider.getStockByTicker(ticker),
            shouldRebuild: (prev, next) => prev != next,
            builder: (_, stock, __) => StockTile(stock: stock),
          );
        },
      )
    );
  }
}