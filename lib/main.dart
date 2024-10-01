import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tripsplit/models/trip_model.dart';
import 'package:tripsplit/models/user_model.dart';
import 'package:tripsplit/providers/connectivity_provider.dart';

import './routes/route.dart';
import './screens/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
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
    // final materialTheme = MaterialTheme(ThemeData.light().textTheme);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>.value(value: _userModel),
        ChangeNotifierProvider<TripModel>.value(value: _tripModel),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TripSplit',
        theme: ThemeData(
          fontFamily: 'Inter',
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
          // colorScheme: ColorScheme.fromSwatch(
          //   primarySwatch: const Color(0xff0041d3).toMaterialColor(),
          //   accentColor: const Color(0xffe9f1fd).withOpacity(0.5),
          //   brightness: Brightness.light,
          //   backgroundColor: Colors.red,
          //   cardColor: const Color(0xFFF0F0F6),
          //   errorColor: Colors.redAccent,
          // ),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: false,
            titleTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.light,
        routes: Routes.getAll(),
        onGenerateRoute: Routes.onGenerateRoute,
        scrollBehavior: const ClampingScrollBehavior(),
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
