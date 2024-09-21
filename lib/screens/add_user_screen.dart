import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tripsplit/common/extensions/extensions.dart';
import 'package:tripsplit/models/trip_model.dart';
import 'package:tripsplit/widgets/custom/custom_card.dart';
import 'package:tripsplit/widgets/custom/custom_text_form_field.dart';

import '../widgets/custom/custom_button.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor.computedLuminance(),
          ),
        ),
        title: const Text('Add User'),
        titleTextStyle: TextStyle(
          color: Theme.of(context).primaryColor.computedLuminance(),
          fontSize: 24.0,
          fontWeight: FontWeight.w800,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Consumer<TripModel>(
        builder: (context, tripModel, _) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        // height: 150.0,
                        padding: const EdgeInsets.fromLTRB(
                          15.0,
                          15.0,
                          15.0,
                          30.0,
                        ),
                        width: double.infinity,
                        color: Theme.of(context).primaryColor,
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                "Share this code with the user to add them to the trip.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .primaryColor
                                      .computedLuminance(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                tripModel.selectedTrip!.inviteCode!.length,
                                (index) => CustomCard(
                                  width: 50.0,
                                  height: 50.0,
                                  hasShadow: false,
                                  child: Center(
                                    child: Text(
                                      tripModel
                                          .selectedTrip!.inviteCode![index],
                                      style: const TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20.0),
                            const Center(
                              child: Text(
                                'Create a Guest Account',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            const Center(
                              child: Text(
                                "Enter the user's details to add them to the trip.",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            CustomTextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                hintText: 'John',
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            CustomTextFormField(
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                hintText: 'Doe',
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 25.0),
                            CustomButton(
                              text: 'Add Guest User',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 0.3,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.route_rounded),
                    const SizedBox(width: 15.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tripModel.selectedTrip!.title!),
                        Text(
                          '${DateFormat.yMMMd().format(tripModel.selectedTrip!.startDate!)} - ${DateFormat.yMMMd().format(tripModel.selectedTrip!.endDate!)}',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Theme.of(context).dividerColor.darken(0.2),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
