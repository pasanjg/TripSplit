import 'package:flutter/material.dart';
import 'package:tripsplit/common/extensions/extensions.dart';

class CustomButton extends StatelessWidget {
  final double? width;
  final String text;
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool block;
  final bool loading;

  const CustomButton({
    super.key,
    this.width,
    this.text = '',
    this.child = const SizedBox(),
    this.backgroundColor,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius = 10.0,
    this.onTap,
    this.block = false,
    this.loading = false,
  });

  Widget _buildButtonChild(BuildContext context) {
    if (loading) {
      return SizedBox(
        height: 20.0,
        width: 20.0,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          color: backgroundColor != null
              ? backgroundColor?.computedLuminance()
              : Theme.of(context).primaryColor.computedLuminance(),
        ),
      );
    }

    if (text.isNotEmpty) {
      return Text(
        text,
        style: TextStyle(
          color: backgroundColor != null
              ? backgroundColor?.computedLuminance()
              : Theme.of(context).primaryColor.computedLuminance(),
        ),
      );
    }

    return child;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
        child: Container(
          padding: padding,
          width: block ? double.infinity : width,
          decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
          child: Center(
            child: _buildButtonChild(context),
          ),
        ),
      ),
    );
  }
}
