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

        return ExpenseRecord(tripModel: tripModel);
      },
    );
  }
}
