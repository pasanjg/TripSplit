import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripsplit/common/constants/constants.dart';
import 'package:tripsplit/common/extensions/extensions.dart';
import 'package:tripsplit/models/trip_model.dart';
import 'package:tripsplit/widgets/dashboard/expenses_list.dart';
import 'package:tripsplit/widgets/dashboard/users_list.dart';
import 'package:tripsplit/widgets/dashboard/users_list_item.dart';
import 'package:tripsplit/widgets/dashboard/expense_record.dart';
import 'package:tripsplit/widgets/trips/trip_selector.dart';

import '../widgets/custom/index.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  SampleItem? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: const [
          TripSelector(),
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer<TripModel>(builder: (context, tripModel, _) {
          return Padding(
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
                          const SizedBox(height: 5.0),
                          const Text(
                            'LKR 10,000.00',
                            style: TextStyle(
                              fontSize: 32.0,
                              height: 1.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: PopupMenuButton<SampleItem>(
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: Theme.of(context).dividerColor,
                        ),
                        initialValue: selectedItem,
                        onSelected: (SampleItem item) {
                          setState(() {
                            selectedItem = item;
                          });
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<SampleItem>>[
                          const PopupMenuItem<SampleItem>(
                            value: SampleItem.itemOne,
                            child: Text('Total Spent'),
                          ),
                          const PopupMenuItem<SampleItem>(
                            value: SampleItem.itemTwo,
                            child: Text('My Spending'),
                          ),
                          const PopupMenuItem<SampleItem>(
                            value: SampleItem.itemThree,
                            child: Text('Amounts Owed'),
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
                    const Text(
                      "Users",
                      style: TextStyle(
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
                        onPressed: () {},
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
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
