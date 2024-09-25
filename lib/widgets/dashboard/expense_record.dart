import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripsplit/common/constants/constants.dart';

import '../../entities/expense.dart';
import '../custom/custom_card.dart';

class ExpenseRecord extends StatelessWidget {
  final String date;
  final List<Expense> expenses;

  const ExpenseRecord({
    super.key,
    required this.date,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      width: double.infinity,
      padding: const EdgeInsets.all(15.0),
      header: Text(date),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          expenses.length,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: ExpenseRecordItem(
              expense: expenses[index],
            ),
          ),
        ),
      ),
    );
  }
}

class ExpenseRecordItem extends StatelessWidget {
  final Expense expense;

  const ExpenseRecordItem({
    super.key,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Category.getCategory(expense.category!).icon,
          size: 14.0,
          color: Theme.of(context).primaryColor.withOpacity(0.8),
        ),
        const SizedBox(width: 5.0),
        Expanded(
          child: Text(
            expense.title!,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(NumberFormat.currency(
          symbol: 'LKR ',
        ).format(expense.amount)),
        const SizedBox(width: 5.0),
        Icon(
          Icons.chevron_right_rounded,
          color: Theme.of(context).dividerColor,
        ),
      ],
    );
  }
}
