import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../models/trip_model.dart';
import '../../widgets/custom/custom_card.dart';
import '../../widgets/dashboard/users_list_item.dart';

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
        stream: tripModel.tripUsersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CustomCard(
              child: Skeletonizer(
                child: Column(
                  children: List.generate(
                    2,
                    (index) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20.0,
                          ),
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Bone.text(),
                              SizedBox(height: 5.0),
                              Bone.text(words: 2),
                            ],
                          ),
                          Spacer(),
                          Bone.icon()
                        ],
                      ),
                    ),
                  ),
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
            itemHeight: 47.0,
            visibleItems: 2,
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            children: List.generate(
              snapshot.data!.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.5),
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
