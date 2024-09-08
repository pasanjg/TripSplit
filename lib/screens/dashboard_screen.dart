import 'package:flutter/material.dart';
import 'package:tripsplit/common/extensions/extensions.dart';
import 'package:tripsplit/common/helpers/ui_helper.dart';
import 'package:tripsplit/widgets/companion_item.dart';
import 'package:tripsplit/widgets/custom_button.dart';
import 'package:tripsplit/widgets/custom_list_item.dart';
import 'package:tripsplit/widgets/expandable_custom_card.dart';
import 'package:tripsplit/widgets/expense_record.dart';

import '../widgets/custom_card.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  SampleItem? selectedItem;

  void showTrips(BuildContext context) {
    UIHelper.of(context).showCustomBottomSheet(
      header: Container(
        padding: const EdgeInsets.only(top: 10.0, right: 15.0, left: 15.0),
        width: double.infinity,
        child: Column(
          children: [
            const Text(
              'Select a trip',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Select a trip to view the logbook',
              style: TextStyle(
                fontSize: 14.0,
                color: Theme.of(context).dividerColor.darken(0.2),
              ),
            ),
          ],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              CustomListItem(
                content: const Text('Trip 1'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              CustomListItem(
                content: const Text('Trip 2'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              CustomListItem(
                content: const Text('Trip 3'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              CustomListItem(
                content: const Text('Trip 3'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              CustomListItem(
                content: const Text('Trip 3'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
      footer: Container(
        padding: const EdgeInsets.only(top: 10.0, right: 15.0, left: 15.0),
        width: double.infinity,
        child: CustomButton(
          onTap: () {
            Navigator.of(context).pop();
          },
          text: 'Add New Trip',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: FilledButton.tonal(
              onPressed: () => showTrips(context),
              style: const ButtonStyle(
                visualDensity: VisualDensity.compact,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.route_rounded,
                    color: Theme.of(context).primaryColor.darken(0.2),
                    size: 20.0,
                  ),
                  const SizedBox(width: 5.0),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 150.0),
                    child: Text(
                      'Galle',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor.darken(0.2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                            fontSize: 16.0,
                            color: Theme.of(context).dividerColor.darken(0.2),
                          ),
                        ),
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
                      icon: const Icon(Icons.more_horiz_rounded),
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
                          child: Text('Item 1'),
                        ),
                        const PopupMenuItem<SampleItem>(
                          value: SampleItem.itemTwo,
                          child: Text('Item 2'),
                        ),
                        const PopupMenuItem<SampleItem>(
                          value: SampleItem.itemThree,
                          child: Text('Item 3'),
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
                    "Companions",
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
                        CompanionItem(),
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
