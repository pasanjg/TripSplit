import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  final String text;
  final double fontSize;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color color;
  final double borderRadius;

  const CustomBadge({
    super.key,
    this.text = "",
    this.fontSize = 14.0,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 5.0,
      vertical: 2.0,
    ),
    this.margin = EdgeInsets.zero,
    this.color = Colors.grey,
    this.borderRadius = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
        ),
      ),
    );
  }
}
