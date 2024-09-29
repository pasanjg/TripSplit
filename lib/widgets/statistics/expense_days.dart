import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tripsplit/common/helpers/helpers.dart';
import 'package:tripsplit/widgets/charts/bar_chart.dart';
import 'package:tripsplit/widgets/custom/custom_card.dart';

import '../../models/trip_model.dart';
import '../../models/user_model.dart';
import '../../screens/statistics_screen.dart';

class ExpenseDays extends StatefulWidget {
  final SpendingType spendingType;

  const ExpenseDays({
    super.key,
    required this.spendingType,
  });

  @override
  State<ExpenseDays> createState() => _ExpenseDaysState();
}

class _ExpenseDaysState extends State<ExpenseDays> {
  List<BarChartGroupData> barChartGroupData = [];
  List<String> xValues = [];

  double totalExpenses = 0.0;
  late String title = '';
  late SpendingType spendingType;

  final String dateFormat = 'MMM d';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSpending();
    });
  }

  @override
  void didUpdateWidget(covariant ExpenseDays oldWidget) {
    super.didUpdateWidget(oldWidget);
    loadSpending();
  }

  void loadSpending() {
    spendingType = widget.spendingType;
    switch (spendingType) {
      case SpendingType.totalSpending:
        loadTotalSpending();
        break;
      case SpendingType.mySpending:
        loadMySpending();
        break;
      case SpendingType.spendingByUsers:
        loadSpendingByUsers();
        break;
    }
  }

  void loadTotalSpending() {
    final tripModel = Provider.of<TripModel>(context, listen: false);

    final expenses = tripModel.selectedTrip!.expenses;
    final dates = expenses.map((e) => e.date!).toSet().toList();
    final dateSum = expenses.fold<Map<String, double>>(
      {},
      (previousValue, element) {
        final date = DateFormat(dateFormat).format(element.date!);
        final amount = element.amount;
        previousValue.update(
          date,
          (value) => value + amount!,
          ifAbsent: () => amount!,
        );
        return previousValue;
      },
    );

    final dateRange = generateDateRange(dates).map((date) {
      return DateFormat(dateFormat).format(date);
    }).toList();
    final dateAmounts = dateRange.map((date) {
      final amount = dateSum[date] ?? 0.0;
      totalExpenses += amount;
      return amount;
    }).toList();

    final barChartGroupData = dateAmounts.asMap().entries.map((entry) {
      final index = entry.key;
      final amount = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: amount,
          ),
        ],
      );
    }).toList();

    final xValues = dateRange;

    setState(() {
      title = "Total Spending";
      this.barChartGroupData = barChartGroupData;
      this.xValues = xValues;
    });
  }

  void loadMySpending() {
    final tripModel = Provider.of<TripModel>(context, listen: false);
    final userModel = Provider.of<UserModel>(context, listen: false);

    final userId = userModel.user!.id;
    final expenses = tripModel.selectedTrip!.expenses;
    final totalUserExpenses = expenses.where((expense) => expense.userRef!.id == userId).toList();
    final dates = totalUserExpenses.map((e) => e.date!).toSet().toList();
    final dateSum = totalUserExpenses.fold<Map<String, double>>(
      {},
      (previousValue, element) {
        final date = DateFormat(dateFormat).format(element.date!);
        final amount = element.amount;
        previousValue.update(
          date,
          (value) => value + amount!,
          ifAbsent: () => amount!,
        );
        return previousValue;
      },
    );

    double total = 0.0;
    final dateRange = generateDateRange(dates).map((date) {
      return DateFormat(dateFormat).format(date);
    }).toList();
    final dateAmounts = dateRange.map((date) {
      final amount = dateSum[date] ?? 0.0;
      total += amount;
      return amount;
    }).toList();

    final barChartGroupData = dateAmounts.asMap().entries.map((entry) {
      final index = entry.key;
      final amount = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: amount,
          ),
        ],
      );
    }).toList();

    final xValues = dateRange;

    setState(() {
      title = "My Spending";
      totalExpenses = total;
      this.barChartGroupData = barChartGroupData;
      this.xValues = xValues;
    });
  }

  void loadSpendingByUsers() {
    final tripModel = Provider.of<TripModel>(context, listen: false);

    final expenses = tripModel.selectedTrip!.expenses;
    final users = tripModel.selectedTrip!.users;
    final userExpenses = users.map((user) {
      final userExpenses = expenses.where((expense) => expense.userRef!.id == user.id).toList();
      final total = userExpenses.fold<double>(0, (prev, expense) => prev + expense.amount!);
      return total;
    }).toList();

    double total = 0.0;
    for (var amount in userExpenses) {
      total += amount;
    }

    final barChartGroupData = userExpenses.asMap().entries.map((entry) {
      final index = entry.key;
      final amount = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: amount,
          ),
        ],
      );
    }).toList();

    final xValues = users.map((user) {
      return "${user.firstname} ${user.lastname![0]}.";
    }).toList();

    setState(() {
      title = "Spending by Users";
      totalExpenses = total;
      this.barChartGroupData = barChartGroupData;
      this.xValues = xValues;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      width: double.infinity,
      padding: const EdgeInsets.all(15.0),
      header: Row(
        children: [
          Text(title),
          const Spacer(),
          Text(
            NumberFormat.currency(
              symbol: 'LKR ',
            ).format(totalExpenses),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      child: BarChartWidget(
        barChartGroupData: barChartGroupData,
        xValues: xValues,
      ),
    );
  }
}
