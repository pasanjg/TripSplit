import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tripsplit/models/trip_model.dart';
import 'package:tripsplit/models/user_model.dart';

import './routes/route.dart';
import './screens/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _userModel = UserModel();
  final _tripModel = TripModel();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>.value(value: _userModel),
        ChangeNotifierProvider<TripModel>.value(value: _tripModel),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TripSplit',
        theme: ThemeData(
          fontFamily: 'Inter',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        routes: Routes.getAll(),
        onGenerateRoute: Routes.onGenerateRoute,
        home: const SplashScreen(),
        builder: (context, child) {
          return ResponsiveBreakpoints.builder(
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            ],
            child: child!,
          );
        },
      ),
    );
  }
}
