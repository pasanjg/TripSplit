import 'package:flutter/material.dart';
import 'package:tripsplit/common/extensions/extensions.dart';
import 'package:tripsplit/widgets/splitmate_list_item.dart';
import 'package:tripsplit/widgets/expense_record.dart';
import 'package:tripsplit/widgets/trip_selector.dart';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Stack(
                children: [
                  CustomCard(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15.0),
                    hasShadow: true,
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
                        const SizedBox(height: 3.0),
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
            ),
            const SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Splitmates",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.person_add_rounded,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ExpandableCustomCard(
                width: double.infinity,
                initialHeight: 150.0,
                expandedHeight: 53.0 * 5,
                padding: const EdgeInsets.all(15.0),
                hasShadow: true,
                child: Column(
                  children: List.generate(
                    5,
                    (index) => const Column(
                      children: [
                        SplitmateListItem(),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Expenses",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add_rounded,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15.0),
            const ExpenseRecord(),
            const SizedBox(height: 15.0),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
