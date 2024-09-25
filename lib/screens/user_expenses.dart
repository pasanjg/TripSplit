import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripsplit/common/extensions/extensions.dart';
import 'package:tripsplit/entities/user.dart';
import 'package:tripsplit/models/trip_model.dart';
import 'package:tripsplit/widgets/dashboard/expense_record.dart';

class UserExpenses extends StatelessWidget {
  final User user;

  const UserExpenses({super.key, required this.user});

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
        title: Text("${user.fullName} ${user.mySelf ? '(You)' : ''}"),
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
      body: Consumer<TripModel>(
        builder: (context, tripModel, _) {
          return Column(
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
                        'LKR 6,785.20',
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
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 12.0,
                      ),
                      child: Text("Expense Record"),
                      // child: ExpenseRecord(),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
