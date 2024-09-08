import 'package:flutter/material.dart';
import '../widgets/custom_list_item.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: [
              CustomListItem(
                onTap: () {},
                leading: const Icon(Icons.auto_awesome),
                content: const Text("Theme"),
                trailing: CircleAvatar(
                  radius: 12.0,
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
              CustomListItem(
                onTap: () {},
                leading: const Icon(Icons.money),
                content: const Text("Currency"),
                trailing: const Text(
                  "LKR",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CustomListItem(
                onTap: () {},
                leading: const Icon(Icons.logout),
                content: const Text("Logout"),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Version 0.1.0",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
