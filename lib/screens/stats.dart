import 'package:flutter/material.dart';

import '../common/constants.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(RouteList.test);
          },
          child: const Text('Stats'),
        ),
      ),
    );
  }
}
