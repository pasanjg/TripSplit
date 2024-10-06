import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import './common/extensions/extensions.dart';
import './models/trip_model.dart';
import './models/user_model.dart';
import './providers/connectivity_provider.dart';
import './services/services.dart';
import './routes/route.dart';
import './screens/splash_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Service.instance.firebase.firestore.settings = const Settings(
    persistenceEnabled: true,
  );

  FlutterError.onError = (errorDetails) {
    Service.instance.firebase.crashlytics.recordFlutterFatalError(errorDetails);
  };

  // Pass all uncaught synchronous errors that aren't handled by the Flutter framework to Crashlytics
  FlutterError.onError = (details) {
    Service.instance.firebase.crashlytics.recordFlutterError(details);
  };

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    Service.instance.firebase.crashlytics.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserModel(
            Service.instance.user,
            Service.instance.connectivity,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => TripModel(
            Service.instance.trip,
            Service.instance.firebase,
            Service.instance.connectivity,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ConnectivityProvider(Service.instance.connectivity),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TripSplit',
        theme: ThemeData(
          fontFamily: 'Inter',
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: false,
            titleTextStyle: TextStyle(
              color: Theme.of(context).primaryColor.contrastColor(),
              fontSize: 24.0,
              fontWeight: FontWeight.w800,
            ),
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor.contrastColor()),
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
