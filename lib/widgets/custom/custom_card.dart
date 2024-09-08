import 'package:flutter/material.dart';
import 'index.dart';

class CustomCard extends StatelessWidget {
  final CustomBadge? badge;
  final double? height;
  final double? width;
  final EdgeInsets? margin;
  final EdgeInsets padding;
  final BoxBorder? border;
  final double radius;
  final bool hasShadow;
  final Color? color;
  final Widget? header;
  final Widget? child;
  final Widget? footer;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const CustomCard({
    super.key,
    this.badge,
    this.height,
    this.width,
    this.margin,
    this.padding = const EdgeInsets.all(10.0),
    this.border,
    this.radius = 10.0,
    this.hasShadow = false,
    this.color,
    this.header,
    this.child,
    this.footer,
    this.onTap,
    this.onLongPress,
  });

  BorderRadius _buildBodyBorderRadius() {
    if (header != null && footer != null) {
      return BorderRadius.zero;
    } else if (header != null) {
      return BorderRadius.only(
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      );
    } else if (footer != null) {
      return BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      );
    } else {
      return BorderRadius.all(Radius.circular(radius));
    }
  }

  BoxBorder? _buildBodyBorder() {
    if (border != null) {
      return null;
    } else if (header != null && footer != null) {
      return Border(
        top: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.15)),
        bottom: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.15)),
        left: const BorderSide(width: 0, color: Colors.transparent),
        right: const BorderSide(width: 0, color: Colors.transparent),
      );
    } else if (header != null) {
      return Border(
        top: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.15)),
        bottom: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.15)),
      );
    } else if (footer != null) {
      return Border(
        top: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.15)),
        bottom: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.15)),
      );
    } else {
      return Border.all(width: 1.0, color: Colors.grey.withOpacity(0.15));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        children: [
          Container(
            margin: margin,
            decoration: BoxDecoration(
              boxShadow: hasShadow
                  ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        spreadRadius: 0.1,
                        blurRadius: 8,
                        offset: const Offset(0, 0),
                      ),
                    ]
                  : [],
              border: border,
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (header != null)
                  // Header Container
                  Container(
                    width: width,
                    padding: EdgeInsets.only(
                      top: padding.top * 0.5,
                      right: padding.right,
                      bottom: padding.bottom * 0.5,
                      left: padding.left,
                    ),
                    decoration: BoxDecoration(
                      color: color ?? Theme.of(context).cardColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(radius),
                        topRight: Radius.circular(radius),
                      ),
                    ),
                    child: header,
                  ),
                // Body Container
                Container(
                  padding: EdgeInsets.only(
                    top: header != null ? padding.top * 0.5 : padding.top,
                    right: padding.right,
                    bottom: footer != null ? padding.bottom * 0.5 : padding.bottom,
                    left: padding.left,
                  ),
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    color: color ?? Theme.of(context).cardColor,
                    border: _buildBodyBorder(),
                    borderRadius: _buildBodyBorderRadius(),
                  ),
                  child: child,
                ),
                if (footer != null)
                  // Footer Container
                  Container(
                    width: width,
                    padding: EdgeInsets.only(
                      top: padding.top * 0.5,
                      right: padding.right,
                      bottom: padding.bottom * 0.5,
                      left: padding.left,
                    ),
                    decoration: BoxDecoration(
                      color: color ?? Theme.of(context).cardColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(radius),
                        bottomRight: Radius.circular(radius),
                      ),
                    ),
                    child: footer,
                  ),
              ],
            ),
          ),
          badge != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 10.0,
                    child: Text(
                      badge != null ? badge!.text : "",
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
