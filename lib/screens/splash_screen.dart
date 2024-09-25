import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripsplit/models/trip_model.dart';
import '../common/constants/constants.dart';
import 'package:tripsplit/models/user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late UserModel userModel;
  late TripModel tripModel;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    if (!context.mounted) return;

    userModel = Provider.of<UserModel>(context, listen: false);
    await userModel.getUser();

    if (userModel.user != null) {
      tripModel = Provider.of<TripModel>(context, listen: false);
      await tripModel.getUserTrips();
    }

    await navigateToNextScreen();
  }

  Future<void> navigateToNextScreen() async {
    if (userModel.user != null) {
      await Navigator.of(context).pushReplacementNamed(RouteNames.home);
    } else {
      await Navigator.of(context).pushReplacementNamed(RouteNames.login);
    }
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
