import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tripsplit/common/helpers/helpers.dart';
import 'package:tripsplit/screens/statistics_screen.dart';

import '../../common/constants/constants.dart';
import '../../models/trip_model.dart';
import '../../models/user_model.dart';
import '../charts/indicator.dart';
import '../charts/pie_chart.dart';
import '../custom/custom_card.dart';

class ExpenseCategorized extends StatefulWidget {
  final SpendingType spendingType;

  const ExpenseCategorized({
    super.key,
    required this.spendingType,
  });

  @override
  State<ExpenseCategorized> createState() => _ExpenseCategorizedState();
}

class _ExpenseCategorizedState extends State<ExpenseCategorized> {
  List<Indicator> indicators = [];
  List<PieChartSectionData> chartData = [];

  double totalExpenses = 0.0;
  late String title = '';
  late SpendingType spendingType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSpending();
    });
  }

  @override
  void didUpdateWidget(covariant ExpenseCategorized oldWidget) {
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
    final expenses = tripModel.selectedTrip?.expenses ?? [];
    final total = expenses.fold<double>(0, (prev, expense) => prev + expense.amount!);
    final categories = expenses.map((category) => category.category!).toSet();

    final indicators = categories.map((expense) {
      return Indicator(
        color: Category.getCategory(expense).color,
        text: Category.getCategory(expense).displayName,
        isSquare: true,
      );
    }).toList();

    final chartData = expenses.map((expense) {
      final category = Category.getCategory(expense.category!);
      return PieChartSectionData(
        color: category.color,
        value: expense.amount! / total,
        title: '${(expense.amount! / total * 100).toStringAsFixed(2)}%',
        radius: 50.0,
        titleStyle: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    setState(() {
      title = "Total Spending";
      totalExpenses = total;
      this.indicators = indicators;
      this.chartData = chartData;
    });
  }

  void loadMySpending() {
    final tripModel = Provider.of<TripModel>(context, listen: false);
    final userModel = Provider.of<UserModel>(context, listen: false);
    final userId = userModel.user?.id;

    final expenses = tripModel.selectedTrip?.expenses ?? [];
    final totalUserExpenses = expenses.where((expense) => expense.userRef!.id == userId).toList();
    final total = totalUserExpenses.fold<double>(0, (prev, expense) => prev + expense.amount!);
    final categories = totalUserExpenses.map((category) => category.category!).toSet();

    final indicators = categories.map((expense) {
      return Indicator(
        color: Category.getCategory(expense).color,
        text: Category.getCategory(expense).displayName,
        isSquare: true,
      );
    }).toList();

    final chartData = totalUserExpenses.map((expense) {
      final category = Category.getCategory(expense.category!);
      return PieChartSectionData(
        color: category.color,
        value: expense.amount! / total,
        title: '${(expense.amount! / total * 100).toStringAsFixed(2)}%',
        radius: 50.0,
        titleStyle: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    setState(() {
      title = "My Spending";
      totalExpenses = total;
      this.indicators = indicators;
      this.chartData = chartData;
    });
  }

  void loadSpendingByUsers() {
    final tripModel = Provider.of<TripModel>(context, listen: false);

    final users = tripModel.selectedTrip?.users ?? [];
    final expenses = tripModel.selectedTrip?.expenses ?? [];
    final total = expenses.fold<double>(0, (prev, expense) => prev + expense.amount!);

    final indicators = users.map((user) {
      return Indicator(
        color: generateColorFromString(user.id!),
        text: "${user.firstname} ${user.lastname![0]}.",
        isSquare: true,
      );
    }).toList();

    final chartData = users.map((user) {
      final userExpenses = expenses.where((expense) => expense.userRef!.id == user.id).toList();
      final totalUserExpenses = userExpenses.fold<double>(0, (prev, expense) => prev + expense.amount!);
      return PieChartSectionData(
        color: generateColorFromString(user.id!),
        value: totalUserExpenses / total,
        title: '${(totalUserExpenses / total * 100).toStringAsFixed(2)}%',
        radius: 50.0,
        titleStyle: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    setState(() {
      title = "Spending by Users";
      totalExpenses = total;
      this.indicators = indicators;
      this.chartData = chartData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomCard(
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
          child: PieChartWidget(
            indicators: indicators,
            chartData: chartData,
          ),
        ),
      ],
    );
  }
}
