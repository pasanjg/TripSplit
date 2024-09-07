import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tripsplit/routes/route.dart';
import 'package:tripsplit/screens/splash_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TripSplit',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(primary: Color(0xFF1F44EA), seedColor: Color(0xFF1F44EA)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(primary: Color(0xFF1F44EA), seedColor: Color(0xFF1F44EA)),
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      routes: Routes.getAll(),
      onGenerateRoute: Routes.onGenerateRoute,
      home: const SplashScreen(),
    );
  }
}
