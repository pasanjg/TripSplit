import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../common/constants/constants.dart';
import '../../common/extensions/extensions.dart';
import '../../mixins/validate_mixin.dart';
import '../../models/trip_model.dart';
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
  OverlayEntry? loader;

  @override
  void initState() {
    super.initState();
    loader = UIHelper.overlayLoader(context);
  }

  void _selectTrip(TripModel tripModel, Trip trip) async {
    Overlay.of(context).insert(loader!);
    await tripModel.selectTrip(trip);
    Navigator.of(context).pop();
    UIHelper.of(context).showSnackBar("Switched to ${trip.title}");
    loader!.remove();
  }

  void showTrips(BuildContext context, TripModel tripModel) {
    UIHelper.of(context).showCustomBottomSheet(
      initialChildSize: 0.5,
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
            return Skeletonizer(
              child: Column(
                children: List.generate(
                  5,
                  (index) => const CustomListItem(
                    leading: Icon(Icons.route_rounded),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Bone.text(words: 2),
                        SizedBox(height: 5.0),
                        Bone.text(),
                      ],
                    ),
                    trailing: SizedBox.shrink(),
                  ),
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('An error occurred'),
            );
          }

          if (snapshot.data != null) {
            return const Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Center(
                child: Text('No trips found. '),
              ),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              snapshot.data!.length,
              (index) {
                final Trip trip = snapshot.data![index];
                return CustomListItem(
                  onTap: () => _selectTrip(tripModel, trip),
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
                      ? const Icon(Icons.check_circle_rounded)
                      : const SizedBox.shrink(),
                );
              },
            ),
          );
        },
      ),
      footer: Container(
        padding: const EdgeInsets.only(top: 10.0, right: 15.0, left: 15.0),
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(RouteNames.createTrip);
                },
                text: 'Add New Trip',
              ),
            ),
            const SizedBox(width: 10.0),
            CustomButton(
              padding: const EdgeInsets.all(14.0),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(RouteNames.createTrip);
              },
              child: Center(
                child: Icon(
                  Icons.manage_search_rounded,
                  color: Theme.of(context).primaryColor.contrastColor(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelector(TripModel tripModel) {
    if (tripModel.selectedTrip != null) {
      return GestureDetector(
        onTap: () => showTrips(context, tripModel),
        child: Row(
          children: [
            Icon(
              size: 20.0,
              Icons.route_rounded,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 5.0),
            Container(
              constraints: const BoxConstraints(maxWidth: 100.0),
              child: Text(
                tripModel.selectedTrip!.title!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(RouteNames.createTrip);
        },
        child: Row(
          children: [
            Icon(
              Icons.add_location_alt_rounded,
              color: Theme.of(context).primaryColor,
              size: 20.0,
            ),
            const SizedBox(width: 5.0),
            Container(
              constraints: const BoxConstraints(maxWidth: 100.0),
              child: Text(
                "New Trip",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TripModel>(
      builder: (context, tripModel, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: _buildSelector(tripModel),
        );
      },
    );
  }
}
