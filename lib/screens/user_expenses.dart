import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tripsplit/common/extensions/extensions.dart';
import 'package:tripsplit/entities/user.dart';
import 'package:tripsplit/models/trip_model.dart';
import 'package:tripsplit/widgets/dashboard/expense_record.dart';

import '../entities/expense.dart';

class UserExpenses extends StatefulWidget {
  final User user;

  const UserExpenses({super.key, required this.user});

  @override
  State<UserExpenses> createState() => _UserExpensesState();
}

class _UserExpensesState extends State<UserExpenses> {
  bool isLoading = true;
  late double totalExpenses;
  late Map<String, List<Expense>> userExpenses;

  @override
  void initState() {
    super.initState();
    getUserExpenses();
  }

  void getUserExpenses() {
    final tripModel = Provider.of<TripModel>(context, listen: false);
    setState(() {
      totalExpenses = tripModel.getUserExpensesTotal(widget.user.id!);
      userExpenses = tripModel.getUserExpenses(widget.user.id!);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor.computedLuminance(),
          ),
        ),
        title: Text(
            "${widget.user.fullName} ${widget.user.mySelf ? '(You)' : ''}"),
        titleTextStyle: TextStyle(
          color: Theme.of(context).primaryColor.computedLuminance(),
          fontSize: 24.0,
          fontWeight: FontWeight.w800,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).primaryColor.computedLuminance(),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    left: 20.0,
                    right: 20.0,
                    bottom: 20.0,
                  ),
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Total Expenses',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context)
                                .primaryColor
                                .computedLuminance(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Center(
                        child: Text(
                          NumberFormat.currency(
                            symbol: 'LKR ',
                          ).format(totalExpenses),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .primaryColor
                                .computedLuminance(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: userExpenses.keys.isNotEmpty
                      ? ListView.builder(
                          itemCount: userExpenses.keys.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 12.0,
                              ),
                              child: ExpenseRecord(
                                date: userExpenses.keys.elementAt(index),
                                expenses: userExpenses[userExpenses.keys.elementAt(index)]!,
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text('No expenses recorded'),
                        ),
                ),
              ],
            ),
    );
  }
}
