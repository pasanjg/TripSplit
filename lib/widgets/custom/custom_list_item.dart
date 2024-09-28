import 'package:flutter/material.dart';

class CustomListItem extends StatelessWidget {
  final Widget leading;
  final Widget content;
  final Widget trailing;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final bool hideDivider;
  final Color color;

  const CustomListItem({
    super.key,
    this.leading = const SizedBox.shrink(),
    this.content = const SizedBox.shrink(),
    this.trailing = const SizedBox.shrink(),
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
    this.onTap,
    this.hideDivider = false,
    this.color = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: padding,
        alignment: Alignment.centerLeft,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          border: !hideDivider
              ? Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 0.3,
                  ),
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                leading,
                const SizedBox(width: 20.0),
                content,
              ],
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
