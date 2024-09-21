import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripsplit/models/trip_model.dart';
import 'package:tripsplit/widgets/custom/custom_card.dart';
import 'package:tripsplit/widgets/dashboard/users_list_item.dart';

import '../custom/expandable_custom_card.dart';

class UsersList extends StatelessWidget {
  const UsersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TripModel>(builder: (context, tripModel, _) {
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
                Text('Please select a trip to view users'),
              ],
            ),
          ),
        );
      }

      return StreamBuilder(
        stream: tripModel.usersStream,
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
                child: Text('An error occurred while fetching users'),
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
                      'No users found',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text('Please add users to the trip'),
                  ],
                ),
              ),
            );
          }

          return ExpandableCustomCard(
            itemHeight: 50.0,
            visibleItems: 3,
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            children: List.generate(
              snapshot.data!.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: UsersListItem(
                  user: snapshot.data![index],
                  isOwner: tripModel.selectedTrip!.createdBy ==
                      snapshot.data![index].id,
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
