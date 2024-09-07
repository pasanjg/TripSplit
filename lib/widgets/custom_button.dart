import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final Color? buttonColor;
  final EdgeInsets padding;
  final double borderRadius;
  final VoidCallback? onTap;

  const CustomButton({
    super.key,
    this.child = const Text('Click'),
    this.buttonColor,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius = 10.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
        child: Container(
          padding: padding,
          width: double.infinity,
          decoration: BoxDecoration(
            color: buttonColor ?? Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
