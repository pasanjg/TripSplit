import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tripsplit/common/extensions/extensions.dart';
import 'package:tripsplit/mixins/validate_mixin.dart';
import 'package:tripsplit/models/trip_model.dart';
import 'package:tripsplit/widgets/custom/custom_card.dart';
import 'package:tripsplit/widgets/custom/custom_list_item.dart';
import 'package:tripsplit/widgets/custom/custom_text_form_field.dart';

import '../common/helpers/ui_helper.dart';
import '../entities/user.dart';
import '../widgets/custom/custom_button.dart';

enum CreateMode { selectGuest, createGuest }

class AssignUserScreen extends StatefulWidget {
  const AssignUserScreen({super.key});

  @override
  State<AssignUserScreen> createState() => _AssignUserScreenState();
}

class _AssignUserScreenState extends State<AssignUserScreen>
    with ValidateMixin {
  String? firstname, lastname;
  List<User> guests = [];
  List<String> selectedGuestIds = [];
  CreateMode mode = CreateMode.createGuest;

  GlobalKey<FormState>? guestFormKey;
  OverlayEntry? loader;

  @override
  void initState() {
    super.initState();
    loader = UIHelper.overlayLoader(context);
    guestFormKey = GlobalKey<FormState>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getGuestUsers();
    });
  }

  void getGuestUsers() async {
    Overlay.of(context).insert(loader!);

    final tripModel = Provider.of<TripModel>(context, listen: false);
    guests = await tripModel.getUserGuests();
    setState(() { });

    loader!.remove();
  }

  void assignGuestUser() async {
    FocusScope.of(context).unfocus();
    if (guestFormKey!.currentState!.validate()) {
      guestFormKey!.currentState!.save();
      Overlay.of(context).insert(loader!);

      final tripModel = Provider.of<TripModel>(context, listen: false);
      await tripModel.assignGuestUser(
        firstname: firstname!,
        lastname: lastname!,
      );

      if (!context.mounted) return;

      if (tripModel.errorMessage != null) {
        UIHelper.of(context).showSnackBar(tripModel.errorMessage!, error: true);
      } else if (tripModel.successMessage != null) {
        UIHelper.of(context).showSnackBar(tripModel.successMessage!);
        Navigator.of(context).pop();
      }

      loader!.remove();
    }
  }

  void assignMultipleGuests() async {
    Overlay.of(context).insert(loader!);

    final tripModel = Provider.of<TripModel>(context, listen: false);
    await tripModel.assignMultipleGuests(selectedGuestIds);

    if (!context.mounted) return;

    if (tripModel.errorMessage != null) {
      UIHelper.of(context).showSnackBar(tripModel.errorMessage!, error: true);
    } else if (tripModel.successMessage != null) {
      UIHelper.of(context).showSnackBar(tripModel.successMessage!);
      Navigator.of(context).pop();
    }

    loader!.remove();
  }

  void showRefreshInviteCode() {
    UIHelper.of(context).showCustomAlertDialog(
      title: 'Refresh Invite Code',
      content: const Text('Are you sure you want to refresh the invite code?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: refreshInviteCode,
          child: const Text('Refresh'),
        ),
      ],
    );
  }

  void refreshInviteCode() async {
    Navigator.of(context, rootNavigator: true).pop();
    Overlay.of(context).insert(loader!);

    final tripModel = Provider.of<TripModel>(context, listen: false);
    await tripModel.refreshInviteCode();

    if (!context.mounted) return;

    if (tripModel.errorMessage != null) {
      UIHelper.of(context).showSnackBar(tripModel.errorMessage!, error: true);
    } else if (tripModel.successMessage != null) {
      UIHelper.of(context).showSnackBar(tripModel.successMessage!);
    }

    loader!.remove();
  }

  Widget _buildModeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomCard(
          width: 150.0,
          hasShadow: mode == CreateMode.createGuest,
          color: mode == CreateMode.createGuest
              ? Theme.of(context).primaryColor
              : null,
          onTap: () {
            setState(() {
              mode = CreateMode.createGuest;
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_add_rounded,
                color: mode == CreateMode.createGuest
                    ? Theme.of(context).primaryColor.contrastColor()
                    : Colors.black,
              ),
              Text(
                'Create Guest',
                style: TextStyle(
                  fontSize: 12.0,
                  color: mode == CreateMode.createGuest
                      ? Theme.of(context).primaryColor.contrastColor()
                      : Colors.black,
                ),
              ),
            ],
          ),
        ),
        CustomCard(
          width: 150.0,
          hasShadow: mode == CreateMode.selectGuest,
          color: mode == CreateMode.selectGuest
              ? Theme.of(context).primaryColor
              : null,
          onTap: () {
            if (guests.isEmpty) {
              UIHelper.of(context).showSnackBar('No guests available');
              return;
            }
            setState(() {
              mode = CreateMode.selectGuest;
            });
          },
          child: Column(
            children: [
              Icon(
                Icons.person_search_rounded,
                color: mode == CreateMode.selectGuest
                    ? Theme.of(context).primaryColor.contrastColor()
                    : Colors.black,
              ),
              Text(
                'Select Guests',
                style: TextStyle(
                  fontSize: 12.0,
                  color: mode == CreateMode.selectGuest
                      ? Theme.of(context).primaryColor.contrastColor()
                      : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreateModes() {
    if (mode == CreateMode.createGuest) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30.0),
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
                "Enter the user's details to add them to the trip",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20.0),
            CustomTextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              onSaved: (input) => firstname = input,
              validator: validateText,
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
              onSaved: (input) => lastname = input,
              validator: validateText,
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
              onTap: assignGuestUser,
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            const SizedBox(height: 30.0),
            const Center(
              child: Text(
                'Select Guest User',
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
                "Select a user from the list below to add them to the trip",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CustomCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: guests.map((guest) {
                    return CustomListItem(
                      hideDivider: guests.last == guest,
                      color: selectedGuestIds.contains(guest.id)
                          ? Theme.of(context).primaryColor.withOpacity(0.3)
                          : Colors.transparent,
                      leading: CircleAvatar(
                        radius: 18.0,
                        child: Text(
                          guest.initials,
                          style: const TextStyle(fontSize: 12.0),
                        ),
                      ),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            guest.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Created ${DateFormat.yMMMd().format(guest.createdAt!)}",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Theme.of(context).dividerColor.darken(0.2),
                            ),
                          ),
                        ],
                      ),
                      trailing: selectedGuestIds.contains(guest.id)
                          ? const Icon(Icons.check_circle_rounded)
                          : Icon(
                              Icons.circle_outlined,
                              color: Theme.of(context).dividerColor,
                            ),
                      onTap: () {
                        setState(() {
                          if (selectedGuestIds.contains(guest.id)) {
                            selectedGuestIds.remove(guest.id);
                          } else {
                            selectedGuestIds.add(guest.id!);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 25.0),
            CustomButton(
              disabled: selectedGuestIds.isEmpty,
              text: selectedGuestIds.isEmpty
                  ? 'Select Guest User'
                  : 'Add ${selectedGuestIds.length} Guest(s)',
              onTap: assignMultipleGuests,
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign User'),
        titleTextStyle: TextStyle(
          color: Theme.of(context).primaryColor.contrastColor(),
          fontSize: 24.0,
          fontWeight: FontWeight.w800,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              final tripModel = Provider.of<TripModel>(context, listen: false);
              final String? text = tripModel.selectedTrip!.inviteCode;

              if (text != null) {
                Clipboard.setData(ClipboardData(text: text));
                UIHelper.of(context).showSnackBar('Invite code copied to clipboard');
              }
            },
            icon: Icon(
              Icons.copy_rounded,
              color: Theme.of(context).primaryColor.contrastColor(),
            ),
          ),
          IconButton(
            onPressed: showRefreshInviteCode,
            icon: Icon(
              Icons.refresh_rounded,
              color: Theme.of(context).primaryColor.contrastColor(),
            ),
          )
        ],
      ),
      body: Consumer<TripModel>(
        builder: (context, tripModel, _) {
          return SingleChildScrollView(
            child: Form(
              key: guestFormKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                      top: 15.0,
                      right: 15.0,
                      bottom: 30.0,
                    ),
                    width: double.infinity,
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      children: [
                        Text(
                          "Share this code with the user to add them to the trip",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor.contrastColor(),
                          ),
                        ),
                        const SizedBox(height: 20.0),
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
                                  tripModel.selectedTrip!.inviteCode![index],
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
                        const SizedBox(height: 20.0),
                        Text(
                          'or create a guest account below',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Theme.of(context).primaryColor.contrastColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomListItem(
                    leading: const Icon(Icons.route_rounded),
                    content: Column(
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
                    ),
                    trailing: Row(
                      children: [
                        Icon(
                          Icons.group_rounded,
                          color: Theme.of(context).dividerColor,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          '${tripModel.selectedTrip!.users.length}',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  if (guests.isNotEmpty)
                    _buildModeSelector(),
                  _buildCreateModes(),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
