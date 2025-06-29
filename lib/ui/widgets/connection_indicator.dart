import 'package:flutter/material.dart';

import '../../utils/enums.dart';

class ConnectionIndicator extends StatelessWidget {
  final ConnectionStatus status;

  const ConnectionIndicator({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;

    switch (status) {
      case ConnectionStatus.connecting:
        text = 'Connecting';
        color = Colors.orange;
        break;
      case ConnectionStatus.connected:
        text = 'Connected';
        color = Colors.green;
        break;
      case ConnectionStatus.reconnecting:
        text = 'Reconnecting';
        color = Colors.red;
        break;
      case ConnectionStatus.disconnected:
      default:
        text = 'Disconnected';
        color = Colors.grey;
    }

    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 12),
        const SizedBox(width: 5),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }
}