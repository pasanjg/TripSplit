import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tripsplit/routes/route.dart';
import 'package:tripsplit/widgets/pop_scope.dart';

import '../common/constants/constants.dart';

class MainTabs extends StatefulWidget {
  const MainTabs({super.key});

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  final List<Widget> _tabView = [];
  int currentTabIndex = 0;
  final defaultTabIndex = 0;
  final navigators = <int, GlobalKey<NavigatorState>>{};

  final List<Map<String, dynamic>> tabData = [
    {
      'title': 'Logbook',
      'icon': Icons.home,
      'route': RouteList.logbook,
    },
    {
      'title': 'Stats',
      'icon': Icons.pie_chart,
      'route': RouteList.stats,
    },
    {
      'title': 'Settings',
      'icon': Icons.settings,
      'route': RouteList.settings,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTabData();
  }

  void _initTabData() {
    var tabView = <Widget>[];
    for (var i = 0; i < tabData.length; i++) {
      final initialRoute = tabData[i]['route'];
      navigators[i] = GlobalKey<NavigatorState>();
      tabView.add(
        Navigator(
          key: navigators[i],
          initialRoute: initialRoute,
          onGenerateRoute: Routes.onGenerateRoute,
        ),
      );
    }

    if (tabView.isNotEmpty) {
      _tabView.clear();
      _tabView.addAll(tabView);
    }
  }

  void _onTapTabBar(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  Future<bool> _handlePopScopeRoot() async {
    final currentNavigator = navigators[currentTabIndex]!;
    if (currentNavigator.currentState!.canPop()) {
      currentNavigator.currentState!.pop();
      return false;
    }

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return false;
    }

    if (currentTabIndex != defaultTabIndex) {
      setState(() {
        currentTabIndex = defaultTabIndex;
      });
      return false;
    } else {
      final isAllowExit = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Are you sure?"),
          content: const Text("Do you want to exit the app?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Yes"),
            ),
          ],
        ),
      );

      if (isAllowExit) {
        Future.delayed(const Duration(milliseconds: 250), () {
          exit(0);
        });
      }

      return Future.delayed(const Duration(milliseconds: 100), () {
        return isAllowExit;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScopeWidget(
      onWillPop: _handlePopScopeRoot,
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentTabIndex,
          onDestinationSelected: _onTapTabBar,
          destinations: tabData.map((e) {
            return NavigationDestination(
              icon: Icon(e['icon']),
              label: e['title'],
            );
          }).toList(),
        ),
        body: Center(
          child: _tabView[currentTabIndex],
        ),
      ),
    );
  }
}
