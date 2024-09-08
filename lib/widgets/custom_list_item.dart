import 'package:flutter/material.dart';

class CustomListItem extends StatelessWidget {
  final Widget leading;
  final Widget content;
  final Widget trailing;
  final VoidCallback? onTap;

  const CustomListItem({
    super.key,
    this.leading = const SizedBox.shrink(),
    this.content = const SizedBox.shrink(),
    this.trailing = const SizedBox.shrink(),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        alignment: Alignment.centerLeft,
        height: 55.0,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.3,
            ),
          ),
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
