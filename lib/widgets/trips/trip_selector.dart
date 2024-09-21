import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tripsplit/common/extensions/extensions.dart';
import 'package:tripsplit/mixins/validate_mixin.dart';
import 'package:tripsplit/models/trip_model.dart';
import 'package:tripsplit/widgets/trips/create_trip.dart';

import '../../common/helpers/ui_helper.dart';
import '../../entities/trip.dart';
import '../custom/custom_button.dart';
import '../custom/custom_list_item.dart';

class TripSelector extends StatefulWidget {
  const TripSelector({super.key});

  @override
  State<TripSelector> createState() => _TripSelectorState();
}

class _TripSelectorState extends State<TripSelector> with ValidateMixin {
  void showTrips(BuildContext context, TripModel tripModel) {
    UIHelper.of(context).showCustomBottomSheet(
      initialChildSize: 0.45,
      header: Container(
        padding: const EdgeInsets.only(top: 10.0, right: 15.0, left: 15.0),
        width: double.infinity,
        child: Column(
          children: [
            const Text(
              'Select a trip',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Select a trip to view the logbook',
              style: TextStyle(
                fontSize: 14.0,
                color: Theme.of(context).dividerColor.darken(0.2),
              ),
            ),
          ],
        ),
      ),
      content: StreamBuilder(
        stream: tripModel.userTripsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('An error occurred'),
            );
          }

          if (snapshot.data == null) {
            return const Center(
              child: Text('No trips found'),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(snapshot.data!.length, (index) {
              final Trip trip = snapshot.data![index];
              return CustomListItem(
                  onTap: () {
                    tripModel.selectTrip(trip);
                    Navigator.of(context).pop();
                  },
                  leading: const Icon(Icons.route_rounded),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trip.title!),
                      Text(
                        '${DateFormat.yMMMd().format(trip.startDate!)} - ${DateFormat.yMMMd().format(trip.endDate!)}',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Theme.of(context).dividerColor.darken(0.2),
                        ),
                      ),
                    ],
                  ),
                  trailing: tripModel.selectedTrip!.id == trip.id
                      ? const Icon(Icons.check_rounded)
                      : const SizedBox.shrink());
            }),
          );
        },
      ),
      footer: CreateTrip(
        tripModel: tripModel,
        child: Container(
          padding: const EdgeInsets.only(top: 10.0, right: 15.0, left: 15.0),
          width: double.infinity,
          child: const CustomButton(
            text: 'Add New Trip',
          ),
        ),
      ),
    );
  }

  Widget _buildSelector(TripModel tripModel) {
    return StreamBuilder(
      stream: tripModel.userTripsStream,
      builder: (context, snapshot) {
        print("TRIP SELECTOR DATA: ${snapshot.data}");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        if (snapshot.data == null) {
          return CreateTrip(
            tripModel: tripModel,
            child: Row(
              children: [
                const Icon(
                  Icons.route_rounded,
                  size: 20.0,
                ),
                const SizedBox(width: 5.0),
                Container(
                  constraints: const BoxConstraints(maxWidth: 150.0),
                  child: const Text(
                    "Add New",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }

        if (snapshot.data!.isNotEmpty) {
          return GestureDetector(
            onTap: () => showTrips(context, tripModel),
            child: Row(
              children: [
                const Icon(
                  Icons.route_rounded,
                  size: 20.0,
                ),
                const SizedBox(width: 5.0),
                Container(
                  constraints: const BoxConstraints(maxWidth: 150.0),
                  child: Text(
                    tripModel.selectedTrip!.title!,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        } else {
          return CreateTrip(
            tripModel: tripModel,
            child: Row(
              children: [
                const Icon(
                  Icons.add_circle_rounded,
                  size: 20.0,
                ),
                const SizedBox(width: 5.0),
                Container(
                  constraints: const BoxConstraints(maxWidth: 100.0),
                  child: const Text(
                    "New Trip",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Consumer<TripModel>(builder: (context, tripModel, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: _buildSelector(tripModel),
        );
      }),
    );
  }
}
