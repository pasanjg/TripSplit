import 'package:flutter/material.dart';
import '../common/constants/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp().then((_) {
      navigateToHomeScreen();
    });
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  void navigateToHomeScreen() async {
    // await Navigator.of(context).pushReplacementNamed(RouteList.login);
    await Navigator.of(context).pushReplacementNamed(RouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}