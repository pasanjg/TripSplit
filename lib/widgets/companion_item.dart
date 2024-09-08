import 'package:flutter/material.dart';

class CompanionItem extends StatelessWidget {
  const CompanionItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CircleAvatar(
          radius: 20.0,
        ),
        const SizedBox(width: 10.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'LKR 5,000.00',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Spacer(),
        const Icon(
          Icons.chevron_right_rounded,
          color: Colors.grey,
        ),
      ],
    );
  }
}

