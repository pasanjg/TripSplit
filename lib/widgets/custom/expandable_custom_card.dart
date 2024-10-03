import 'package:flutter/material.dart';

import '../../common/extensions/extensions.dart';

import 'index.dart';

class ExpandableCustomCard extends StatefulWidget {
  final List<Widget> children;
  final double itemHeight;
  final double? width;
  final int visibleItems;
  final EdgeInsets padding;
  final bool hasShadow;

  const ExpandableCustomCard({
    super.key,
    required this.children,
    required this.itemHeight,
    this.width,
    this.visibleItems = 1,
    this.padding = const EdgeInsets.all(10.0),
    this.hasShadow = true,
  }) : assert(visibleItems > 0);

  @override
  State<ExpandableCustomCard> createState() => _ExpandableCustomCardState();
}

class _ExpandableCustomCardState extends State<ExpandableCustomCard> {
  bool _isExpanded = false;
  late double _initialHeight;
  late double _expandedHeight;
  late int _visibleItems;
  Duration animationDuration = const Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _calculateHeights();
  }

  @override
  void didUpdateWidget(covariant ExpandableCustomCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _calculateHeights();
  }

  void _calculateHeights() {
    _visibleItems = widget.visibleItems > widget.children.length
        ? widget.children.length
        : widget.visibleItems;
    _initialHeight = widget.itemHeight * _visibleItems;
    _expandedHeight = widget.itemHeight * widget.children.length;
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      hasShadow: widget.hasShadow,
      footer: widget.children.length > _visibleItems
          ? GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "See ${_isExpanded ? 'less' : 'more'}",
                    style: const TextStyle(fontSize: 12.0),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Theme.of(context).dividerColor.darken(0.2),
                  ),
                ],
              ),
            )
          : null,
      child: AnimatedContainer(
        duration: animationDuration,
        curve: Curves.easeInOut,
        height: _isExpanded ? _expandedHeight : _initialHeight,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          // physics: _isExpanded
          //     ? const AlwaysScrollableScrollPhysics()
          //     : const NeverScrollableScrollPhysics(),
          child: Wrap(
            children: widget.children,
          ),
        ),
      ),
    );
  }
}
