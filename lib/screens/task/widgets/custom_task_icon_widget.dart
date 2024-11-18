import 'package:flutter/material.dart';

class CustomTaskIconWidget extends StatelessWidget {
  const CustomTaskIconWidget({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: color,
      ),
    );
  }
}
