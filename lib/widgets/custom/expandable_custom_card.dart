import 'package:flutter/material.dart';
import 'package:tripsplit/common/extensions/extensions.dart';
import 'index.dart';

class ExpandableCustomCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double initialHeight;
  final double expandedHeight;
  final EdgeInsets padding;
  final bool hasShadow;

  const ExpandableCustomCard({
    super.key,
    required this.child,
    this.width,
    required this.initialHeight,
    required this.expandedHeight,
    this.padding = const EdgeInsets.all(10.0),
    this.hasShadow = false,
  });

  @override
  State<ExpandableCustomCard> createState() => _ExpandableCustomCardState();
}

class _ExpandableCustomCardState extends State<ExpandableCustomCard> {
  bool _isExpanded = false;
  Duration animationDuration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      hasShadow: widget.hasShadow,
      footer: GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Theme.of(context).dividerColor.darken(0.2),
            ),
          ],
        ),
      ),
      child: AnimatedContainer(
        duration: animationDuration,
        curve: Curves.easeInOut,
        height: _isExpanded ? widget.expandedHeight : widget.initialHeight,
        child: SingleChildScrollView(
          physics: _isExpanded
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          child: Wrap(
            children: [
              widget.child,
            ],
          ),
        ),
      ),
    );
  }
}
