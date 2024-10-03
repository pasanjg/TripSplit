import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/helpers/ui_helper.dart';
import '../providers/connectivity_provider.dart';

class ConnectivityIndicator extends StatelessWidget {
  const ConnectivityIndicator({super.key});

  void showConnectionDialog(BuildContext context) {
    UIHelper.of(context).showCustomAlertDialog(
      title: 'No internet connection',
      content: const Text(
        'Please check your internet connection. You can still use the app in offline mode with limited features.\n\n'
        'Your data will be synced once you are back online.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivityProvider, _) {
        return !connectivityProvider.isOnline || connectivityProvider.showBackOnline
            ? GestureDetector(
                onTap: () {
                  if (!connectivityProvider.isOnline) {
                    showConnectionDialog(context);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 5.0,
                  ),
                  color: connectivityProvider.showBackOnline
                      ? Colors.green
                      : Colors.red,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 16.0,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          connectivityProvider.showBackOnline
                              ? 'You are back online'
                              : 'You are currently offline',
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox();
      },
    );
  }
}
