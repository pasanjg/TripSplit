import 'dart:async';
import 'package:flutter/material.dart';

import '../extensions/extensions.dart';

class UIHelper {
  final BuildContext _context;

  UIHelper._(this._context);

  static UIHelper of(BuildContext context) => UIHelper._(context);

  static OverlayEntry overlayLoader(context) {
    OverlayEntry loader = OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      return Positioned(
        height: size.height,
        width: size.width,
        top: 0,
        left: 0,
        child: Material(
          color: Colors.white.withOpacity(0.85),
          child: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      );
    });
    return loader;
  }

  static hideLoader(OverlayEntry? loader) {
    Timer(const Duration(milliseconds: 500), () {
      try {
        loader?.remove();
      } catch (e) {
        //
      }
    });
  }

  showSnackBar(
    String message, {
    SnackBarAction? action,
    Duration? duration,
    bool error = false,
  }) {
    ScaffoldMessenger.of(_context).clearSnackBars();
    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 5),
        backgroundColor: error ? Theme.of(_context).colorScheme.error : Colors.black,
        action: action,
      ),
    );
  }

  showCustomBottomSheet({
    required Widget content,
    bool showClose = false,
    bool isRounded = false,
    bool hasHandle = true,
    double initialChildSize = 0.6,
    double minChildSize = 0.3,
    double maxChildSize = 0.9,
    bool expand = false,
    Widget? header,
    Widget? footer,
  }) {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      context: _context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ), // Handle keyboard overlap
          child: Stack(
            children: [
              showClose
                  ? Positioned(
                      right: 0,
                      child: IconButton(
                        splashRadius: 20.0,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close_rounded,
                          color: Theme.of(_context)
                              .colorScheme
                              .secondary
                              .darken(0.1),
                          size: 20.0,
                        ),
                      ),
                    )
                  : const SizedBox(),
              DraggableScrollableSheet(
                initialChildSize: initialChildSize,
                minChildSize: minChildSize,
                maxChildSize: maxChildSize,
                expand: false,
                builder: (BuildContext context, ScrollController controller) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      hasHandle
                          ? Container(
                              margin: const EdgeInsets.only(top: 8.0),
                              height: 8.0,
                              width: MediaQuery.of(context).size.width * 0.2,
                              decoration: BoxDecoration(
                                color: Theme.of(_context)
                                    .colorScheme
                                    .secondary
                                    .darken(0.1),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      if (header != null) header,
                      Expanded(
                        child: SingleChildScrollView(
                          controller: controller,
                          scrollDirection: Axis.vertical,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: hasHandle && header == null ? 30.0 : 0.0,
                            ),
                            child: content,
                          ),
                        ),
                      ),
                      if (footer != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: footer,
                        ),
                    ],
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> showCustomAlertDialog({
    required String title,
    required Widget content,
    required List<Widget> actions,
    EdgeInsets contentPadding = const EdgeInsets.symmetric(
      horizontal: 20.0,
      vertical: 20.0,
    ),
  }) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      contentPadding: contentPadding,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
      content: SingleChildScrollView(
        child: content,
      ),
      actions: actions,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
    );

    return showDialog(
      context: _context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
