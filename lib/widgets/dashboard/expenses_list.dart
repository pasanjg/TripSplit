import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripsplit/models/trip_model.dart';

import '../custom/custom_card.dart';
import 'expense_record.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TripModel>(
      builder: (context, tripModel, _) {
        if (tripModel.selectedTrip == null) {
          return const CustomCard(
            padding: EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 20.0,
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'No trip selected',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text('Please select a trip to view expenses'),
                ],
              ),
            ),
          );
        }

        return StreamBuilder(
          stream: tripModel.tripExpensesStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CustomCard(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return const CustomCard(
                height: 80.0,
                child: Center(
                  child: Text('An error occurred while fetching expenses'),
                ),
              );
            }

            if (snapshot.data == null) {
              return const CustomCard(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 20.0,
                ),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'No expenses recorded',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text('Please add expenses to view here'),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: List.generate(
                snapshot.data!.keys.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: ExpenseRecord(
                      date: snapshot.data!.keys.elementAt(index),
                      expenses: snapshot.data![snapshot.data!.keys.elementAt(index)]!,
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
