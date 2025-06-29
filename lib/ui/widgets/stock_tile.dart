import 'package:flutter/material.dart';

import '../../models/stock_model.dart';

class StockTile extends StatefulWidget {
  final Stock stock;
  const StockTile({super.key, required this.stock});

  @override
  State<StockTile> createState() => _StockTileState();
}

class _StockTileState extends State<StockTile> {
  double? oldPrice;

  @override
  void didUpdateWidget(covariant StockTile oldWidget) {
    oldPrice = oldWidget.stock.price;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final price = widget.stock.price;
    final change = oldPrice == null ? 0 : price - oldPrice!;
    final color = change == 0 ? Colors.black : change > 0 ? Colors.green : Colors.red;

    // Display the stock ticker symbol,
    // Show the latest price with color indicating price movement or anomaly
    // Show a warning icon if the stock's data is currently flagged as anomalous
    return ListTile(
      title: Text(widget.stock.ticker),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.stock.price.toStringAsFixed(2),
            style: TextStyle(
              color: widget.stock.isAnomalous ? Colors.orange : color,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (widget.stock.isAnomalous)
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.warning, color: Colors.orange),
            ),
        ],
      ),
    );
  }
}