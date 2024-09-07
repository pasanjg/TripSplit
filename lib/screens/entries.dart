import 'package:flutter/material.dart';
import 'package:tripsplit/common/constants.dart';
import 'package:tripsplit/routes/route.dart';

class EntriesScreen extends StatefulWidget {
  const EntriesScreen({super.key});

  @override
  State<EntriesScreen> createState() => _EntriesScreenState();
}

class _EntriesScreenState extends State<EntriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entries'),
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(RouteList.test);
          },
          child: const Text('Entries'),
        ),
      ),
    );
  }
}
