import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:tripsplit/common/constants/constants.dart';
import 'package:tripsplit/widgets/custom/custom_card.dart';
import '../models/trip_model.dart';
import '../models/user_model.dart';
import '../widgets/custom/custom_list_item.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: [
              Consumer<UserModel>(
                builder: (context, userModel, _) {
                  if (!userModel.isLoggedIn) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(
                      right: 15.0,
                      bottom: 15.0,
                      left: 15.0,
                    ),
                    child: CustomCard(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25.0,
                            child: Text(
                              userModel.user!.initials,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userModel.user!.fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                userModel.user!.email!,
                                style: TextStyle(
                                  color: Theme.of(context).dividerColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              // CustomListItem(
              //   onTap: () {},
              //   leading: const Icon(Icons.auto_awesome),
              //   content: const Text("Theme"),
              //   trailing: CircleAvatar(
              //     radius: 12.0,
              //     backgroundColor: Theme.of(context).primaryColor,
              //   ),
              // ),
              // CustomListItem(
              //   onTap: () {},
              //   leading: const Icon(Icons.money),
              //   content: const Text("Currency"),
              //   trailing: const Text(
              //     "LKR",
              //     style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              Consumer<UserModel>(builder: (context, userModel, _) {
                return CustomListItem(
                  onTap: () async {
                    final tripModel = Provider.of<TripModel>(context, listen: false);

                    if (tripModel.selectedTrip != null) {
                      tripModel.clearSelectedTrip();
                    }

                    if (userModel.isLoggedIn) {
                      userModel.logout();
                    }

                    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                      RouteNames.login,
                      (route) => false,
                    );
                  },
                  leading: const Icon(Icons.logout),
                  content: Text(userModel.isLoggedIn ? "Logout" : "Login"),
                );
              }),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Version ${_packageInfo.version}",
                      style: const TextStyle(
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
