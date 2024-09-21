import 'package:flutter/material.dart';
import 'package:tripsplit/entities/user.dart';

class UsersListItem extends StatelessWidget {
  final User user;

  const UsersListItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
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
            Text(
              user.fullName,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
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
    );
  }
}
