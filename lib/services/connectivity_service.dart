import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService._();

  static final instance = ConnectivityService._();

  Future<bool> checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    return result.isNotEmpty && result.every((ConnectivityResult r) => r != ConnectivityResult.none);
  }

  Stream<bool> get onConnectivityChanged {
    return Connectivity().onConnectivityChanged.map((List<ConnectivityResult> result) {
      return result.isNotEmpty && result.every((ConnectivityResult r) => r != ConnectivityResult.none);
    });
  }
}