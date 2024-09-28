import 'package:flutter/material.dart';
import 'package:tripsplit/widgets/charts/pie_chart.dart';
import 'package:tripsplit/widgets/trips/trip_selector.dart';

import '../widgets/custom/index.dart';

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
        title: const Text('Statistics'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: const [
          TripSelector(),
          SizedBox(width: 15.0),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Categories",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: CustomCard(
                width: double.infinity,
                padding: EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PieChartWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
