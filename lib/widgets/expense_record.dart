import 'package:flutter/material.dart';

import 'custom/custom_card.dart';

class ExpenseRecord extends StatefulWidget {
  const ExpenseRecord({super.key});

  @override
  State<ExpenseRecord> createState() => _ExpenseRecordState();
}

class _ExpenseRecordState extends State<ExpenseRecord> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: CustomCard(
        width: double.infinity,
        padding: EdgeInsets.all(15.0),
        hasShadow: true,
        header: Text(
          'Today',
          style: TextStyle(
              // fontSize: 16.0,
              ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpenseRecordItem(),
            SizedBox(height: 6.0),
            ExpenseRecordItem(),
          ],
        ),
      ),
    );
  }
}

class ExpenseRecordItem extends StatelessWidget {
  const ExpenseRecordItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Dinner',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // const Spacer(),
        Text('LKR 2,000.00'),
        const SizedBox(width: 5.0),
        Icon(
          Icons.chevron_right_rounded,
          color: Theme.of(context).dividerColor,
        ),
      ],
    );
  }
}
