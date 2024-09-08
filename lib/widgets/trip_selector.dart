import 'package:flutter/material.dart';
import 'package:tripsplit/common/extensions/extensions.dart';

import '../common/helpers/ui_helper.dart';
import 'custom/custom_button.dart';
import 'custom/custom_list_item.dart';

class TripSelector extends StatelessWidget {
  const TripSelector({super.key});

  @override
  Widget build(BuildContext context) {
    void showTrips(BuildContext context) {
      UIHelper.of(context).showCustomBottomSheet(
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                CustomListItem(
                  content: const Text('Trip 1'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                CustomListItem(
                  content: const Text('Trip 2'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                CustomListItem(
                  content: const Text('Trip 3'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                CustomListItem(
                  content: const Text('Trip 3'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                CustomListItem(
                  content: const Text('Trip 3'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
        footer: Container(
          padding: const EdgeInsets.only(top: 10.0, right: 15.0, left: 15.0),
          width: double.infinity,
          child: CustomButton(
            onTap: () {
              Navigator.of(context).pop();
            },
            text: 'Add New Trip',
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: FilledButton.tonal(
        onPressed: () => showTrips(context),
        style: const ButtonStyle(
          visualDensity: VisualDensity.compact,
        ),
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
                'Galle',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
