import 'package:flutter/material.dart';
import 'package:tripsplit/services/connectivity_service.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isOnline = true;
  bool _isFirstTime = true;
  bool _showBackOnline = false;

  final ConnectivityService _connectivityService = ConnectivityService.instance;

  bool get isOnline => _isOnline;

  bool get showBackOnline => !_isFirstTime && _showBackOnline;

  ConnectivityProvider() {
    _connectivityService.onConnectivityChanged.listen((bool result) {
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

  Future<void> checkConnectivity() async {
    _isOnline = await _connectivityService.checkConnectivity();
    notifyListeners();
  }
}
