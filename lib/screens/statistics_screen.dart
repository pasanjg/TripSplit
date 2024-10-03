import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../entities/trip.dart';
import '../models/trip_model.dart';
import '../widgets/statistics/expense_categorized.dart';
import '../widgets/statistics/expense_days.dart';
import '../widgets/trips/trip_selector.dart';
import '../widgets/custom/custom_card.dart';

enum SpendingType { totalSpending, mySpending, spendingByUsers }

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  SpendingType spendingCategoryType = SpendingType.totalSpending;
  SpendingType spendingInsightType = SpendingType.totalSpending;

  Future<void> onRefresh() async {
    final tripModel = Provider.of<TripModel>(context, listen: false);
    await tripModel.getUserTrips();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Statistics',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          iconTheme: IconThemeData(color: Colors.black.withOpacity(0.75)),
          actions: const [
            TripSelector(),
            SizedBox(width: 15.0),
          ],
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Selector<TripModel, Trip>(
              selector: (context, tripModel) => tripModel.selectedTrip!,
              builder: (context, selectedTrip, _) {
                if (selectedTrip.expenses.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: CustomCard(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 20.0,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'No expenses recorded',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text('Please add expenses to view statistics'),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Categories",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        PopupMenuButton<SpendingType>(
                          icon: Icon(
                            Icons.more_vert_rounded,
                            color: Theme.of(context).dividerColor,
                          ),
                          initialValue: spendingCategoryType,
                          onSelected: (SpendingType item) {
                            setState(() {
                              spendingCategoryType = item;
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<SpendingType>>[
                            const PopupMenuItem<SpendingType>(
                              value: SpendingType.totalSpending,
                              child: Text('Total Spending'),
                            ),
                            const PopupMenuItem<SpendingType>(
                              value: SpendingType.mySpending,
                              child: Text('My Spending'),
                            ),
                            const PopupMenuItem<SpendingType>(
                              value: SpendingType.spendingByUsers,
                              child: Text('Spending by Users'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    ExpenseCategorized(spendingType: spendingCategoryType),
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        const Text(
                          "Insights",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        PopupMenuButton<SpendingType>(
                          icon: Icon(
                            Icons.more_vert_rounded,
                            color: Theme.of(context).dividerColor,
                          ),
                          initialValue: spendingInsightType,
                          onSelected: (SpendingType item) {
                            setState(() {
                              spendingInsightType = item;
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<SpendingType>>[
                            const PopupMenuItem<SpendingType>(
                              value: SpendingType.totalSpending,
                              child: Text('Total Spending'),
                            ),
                            const PopupMenuItem<SpendingType>(
                              value: SpendingType.mySpending,
                              child: Text('My Spending'),
                            ),
                            const PopupMenuItem<SpendingType>(
                              value: SpendingType.spendingByUsers,
                              child: Text('Spending by Users'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    ExpenseDays(spendingType: spendingInsightType),
                    const SizedBox(height: 20.0),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
