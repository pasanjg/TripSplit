import 'package:flutter/material.dart';
import 'package:tripsplit/entities/user.dart';

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
      child: Row(
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
              const Text(
                'LKR XXXX.XX',
                style: TextStyle(
                  fontSize: 14.0,
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
      ),
    );
  }
}
