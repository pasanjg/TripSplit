import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../common/constants/constants.dart';
import '../common/extensions/extensions.dart';
import '../models/trip_model.dart';
import '../widgets/dashboard/expenses_list.dart';
import '../widgets/dashboard/users_list.dart';
import '../widgets/trips/trip_selector.dart';

import '../widgets/custom/index.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<void> onRefresh(TripModel tripModel) async {
    await tripModel.getUserTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TripModel>(
      builder: (context, tripModel, _) {
        return RefreshIndicator(
          onRefresh: () => onRefresh(tripModel),
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              iconTheme: IconThemeData(color: Colors.black.withOpacity(0.75)),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(RouteNames.joinTrip);
                  },
                  icon: const Icon(Icons.group_add_rounded),
                ),
                const TripSelector(),
                const SizedBox(width: 15.0),
              ],
            ),
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        CustomCard(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total spent',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Theme.of(context).dividerColor.darken(0.2),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                NumberFormat.currency(
                                  symbol: 'LKR ',
                                ).format(tripModel.totalSpent),
                                style: const TextStyle(
                                  fontSize: 32.0,
                                  height: 1.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Users ${tripModel.selectedTrip != null ? tripModel.userCount > 1 ? '(${tripModel.userCount})' : '' : ''}",
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (tripModel.canAddUser)
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(RouteNames.addUser);
                            },
                            icon: const Icon(
                              Icons.person_add_rounded,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    const UsersList(),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Expenses",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (tripModel.canAddExpense)
                          IconButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(RouteNames.addExpense);
                            },
                            icon: const Icon(
                              Icons.add_rounded,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    const ExpensesList(),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
            floatingActionButton: tripModel.canAddExpense
                ? FloatingActionButton(
                    mini: true,
                    onPressed: () {
                      Navigator.of(context).pushNamed(RouteNames.addExpense);
                    },
                    child: const Icon(Icons.add_rounded),
                  )
                : null,
          ),
        );
      },
    );
  }
}
