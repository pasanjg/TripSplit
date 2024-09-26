import 'package:flutter/material.dart';
import 'package:tripsplit/entities/expense.dart';
import 'package:tripsplit/screens/assign_user_screen.dart';
import 'package:tripsplit/screens/join_trip_screen.dart';

import '../common/constants/constants.dart';
import '../entities/user.dart';
import '../layout/main_tabs.dart';
import '../screens/add_update_expense_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/create_trip_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/statistics_screen.dart';
import '../screens/user_expenses.dart';

class Routes {
  static Map<String, WidgetBuilder> getAll() => _routes;

  static final Map<String, WidgetBuilder> _routes = {
    RouteNames.login: (context) => const LoginScreen(),
    RouteNames.register: (context) => const RegisterScreen(),
    RouteNames.home: (context) => const MainTabs(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case RouteNames.dashboard:
        return _buildRoute(settings, (_) => const DashboardScreen());
      case RouteNames.stats:
        return _buildRoute(settings, (_) => const StatsScreen());
      case RouteNames.settings:
        return _buildRoute(settings, (_) => const SettingsScreen());
      case RouteNames.addUser:
        return _buildRoute(settings, (_) => const AssignUserScreen());
      case RouteNames.createTrip:
        return _buildRoute(settings, (_) => const CreateTripScreen());
      case RouteNames.joinTrip:
        return _buildRoute(settings, (_) => const JoinTripScreen());
      case RouteNames.addExpense:
        var expense = arguments is Expense ? arguments : null;
        return _buildRoute(settings, (_) => AddUpdateExpenseScreen(expense: expense ));
      case RouteNames.userExpenses:
        return _buildRoute(settings, (_) => UserExpenses(userId: arguments as String));
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
