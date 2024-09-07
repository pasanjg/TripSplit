import 'package:flutter/material.dart';
import 'package:tripsplit/common/constants/constants.dart';

class LogbookScreen extends StatefulWidget {
  const LogbookScreen({super.key});

  @override
  State<LogbookScreen> createState() => _LogbookScreenState();
}

class _LogbookScreenState extends State<LogbookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logbook'),
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(RouteList.test);
          },
          child: const Text('Logbook'),
        ),
      ),
    );
  }
}
