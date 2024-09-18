import 'package:flutter/material.dart';

class SplitmateListItem extends StatelessWidget {
  const SplitmateListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CircleAvatar(
          radius: 20.0,
        ),
        SizedBox(width: 10.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'John Doe',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'LKR 5,000.00',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Spacer(),
        Icon(
          Icons.chevron_right_rounded,
          color: Colors.grey,
        ),
      ],
    );
  }
}

