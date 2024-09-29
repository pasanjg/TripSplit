import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
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

  late RiveAnimationController _biteController;
  late RiveAnimationController _earController;

  @override
  void initState() {
    super.initState();
    _biteController = OneShotAnimation('bite', autoplay: false);
    _earController = OneShotAnimation('ear', autoplay: false);
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

    await _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    if (userModel.user != null) {
      setState(() {
        _earController.isActive = true;
        _biteController.isActive = true;
      });
      Future.delayed(const Duration(milliseconds: 1500), () {
        Navigator.of(context).pushReplacementNamed(RouteNames.home);
      });
    } else {
      Navigator.of(context).pushReplacementNamed(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.width * 1.5,
          width: MediaQuery.of(context).size.width * 1.5,
          child: RiveAnimation.asset(
            controllers: [_biteController, _earController],
            'assets/rive/hippo.riv',
            fit: BoxFit.cover,
            animations: const ['wave'],
          ),
        ),
      ),
    );
  }
}
