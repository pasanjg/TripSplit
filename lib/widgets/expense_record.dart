import 'package:flutter/material.dart';
import 'package:tripsplit/common/extensions/extensions.dart';

import 'custom_card.dart';

class ExpenseRecord extends StatefulWidget {
  const ExpenseRecord({super.key});

  @override
  State<ExpenseRecord> createState() => _ExpenseRecordState();
}

class _ExpenseRecordState extends State<ExpenseRecord> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: CustomCard(
        width: double.infinity,
        padding: const EdgeInsets.all(15.0),
        hasShadow: true,
        header: const Text(
          'Today',
          style: TextStyle(
            // fontSize: 16.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Dinner',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'LKR 2,000.00',
                  style: TextStyle(
                    color: Theme.of(context).dividerColor.darken(0.2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              children: [
                const Text(
                  'Lunch',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'LKR 1,000.00',
                  style: TextStyle(
                    color: Theme.of(context).dividerColor.darken(0.2),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

