import 'package:flutter/material.dart';
import 'package:tripsplit/common/constants/constants.dart';
import 'package:tripsplit/layout/main_tabs.dart';
import 'package:tripsplit/screens/auth/login_screen.dart';
import 'package:tripsplit/screens/auth/register_screen.dart';
import 'package:tripsplit/screens/logbook_screen.dart';
import 'package:tripsplit/screens/settings_screen.dart';
import 'package:tripsplit/screens/stats_screen.dart';
import 'package:tripsplit/screens/test.dart';

class Routes {
  static Map<String, WidgetBuilder> getAll() => _routes;

  static final Map<String, WidgetBuilder> _routes = {
    RouteList.login: (context) => const LoginScreen(),
    RouteList.register: (context) => const RegisterScreen(),
    RouteList.home: (context) => const MainTabs(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case RouteList.logbook:
        return _buildRoute(settings, (_) => const LogbookScreen());
      case RouteList.stats:
        return _buildRoute(settings, (_) => const StatsScreen());
      case RouteList.settings:
        return _buildRoute(settings, (_) => const SettingsScreen());
      case RouteList.test:
        return _buildRoute(settings, (_) => const TestScreen());
      default:
        return _errorRoute();
    }
  }

  static PageRouteBuilder _buildRoute(
    RouteSettings settings,
    WidgetBuilder builder, {
    bool fullscreenDialog = false,
  }) {
    return PageRouteBuilder(
      settings: settings,
      fullscreenDialog: fullscreenDialog,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.ease;
        Offset startOffset = const Offset(1.0, 0.0); // Default slide from right
        final tween = Tween(begin: startOffset, end: Offset.zero)
            .chain(CurveTween(curve: curve));

        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }

  static Route _errorRoute([String message = 'Page not found']) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(message),
        ),
      );
    });
  }
}
