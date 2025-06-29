import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_tracker/providers/stock_provider.dart';
import 'package:stocks_tracker/ui/screens/stock_tracker_screen.dart';

void main() {
  runApp( ChangeNotifierProvider(create: (_) {
    final provider = StockProvider();
    provider.init();
    return provider;
  }, child: const MyApp()),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Tracker',
      home: const StockTrackerScreen(),
    );
  }
}
