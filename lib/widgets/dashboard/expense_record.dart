import 'package:flutter/material.dart';

import '../custom/custom_card.dart';

class ExpenseRecord extends StatelessWidget {
  const ExpenseRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomCard(
      width: double.infinity,
      padding: EdgeInsets.all(15.0),
      header: Text('Today'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpenseRecordItem(),
          SizedBox(height: 6.0),
          ExpenseRecordItem(),
        ],
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
