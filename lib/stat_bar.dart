import 'package:flutter/material.dart';

class StatBar extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final Color color;

  const StatBar({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: $value/$maxValue'),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value / maxValue,
          color: color,
          backgroundColor: Colors.grey.shade300,
        ),
      ],
    );
  }
}