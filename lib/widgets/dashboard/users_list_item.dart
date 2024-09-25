import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tripsplit/entities/user.dart';
import 'package:tripsplit/models/trip_model.dart';

import '../../common/constants/constants.dart';

class UsersListItem extends StatelessWidget {
  final User user;
  final bool isOwner;

  const UsersListItem({
    super.key,
    required this.user,
    this.isOwner = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          RouteNames.userExpenses,
          arguments: user,
        );
      },
      child: Consumer<TripModel>(builder: (context, tripModel, _) {
        final userTotal = tripModel.getUserExpenses(user.id!);

        return Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              child: Text(
                user.initials,
              ),
            ),
            const SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "${user.fullName} ${user.mySelf ? '(You)' : ''}",
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    if (isOwner)
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16.0,
                      ),
                  ],
                ),
                Text(
                  NumberFormat.currency(
                    symbol: 'LKR ',
                  ).format(userTotal),
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey,
            ),
          ],
        );
      }),
    );
  }
}
