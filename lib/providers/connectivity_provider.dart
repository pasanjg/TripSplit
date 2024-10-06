import 'dart:async';

import 'package:flutter/material.dart';

import '../services/connectivity_service.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isOnline = true;
  bool _isFirstTime = true;
  bool _showBackOnline = false;
  StreamSubscription<bool>? _subscription;

  final ConnectivityService _connectivityService;

  bool get isOnline => _isOnline;

  bool get showBackOnline => !_isFirstTime && _showBackOnline;

  ConnectivityProvider(this._connectivityService) {
    _subscription = _connectivityService.onConnectivityChanged.listen((bool result) {
      _isOnline = result;
      notifyListeners();

      if (!_isOnline) {
        _isFirstTime = false;
      } else {
        _showBackOnline = true;
        notifyListeners();
        Future.delayed(const Duration(seconds: 5), () {
          _showBackOnline = false;
          notifyListeners();
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
