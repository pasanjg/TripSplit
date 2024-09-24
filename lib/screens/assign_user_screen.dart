import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tripsplit/common/extensions/extensions.dart';
import 'package:tripsplit/mixins/validate_mixin.dart';
import 'package:tripsplit/models/trip_model.dart';
import 'package:tripsplit/widgets/custom/custom_card.dart';
import 'package:tripsplit/widgets/custom/custom_text_form_field.dart';

import '../common/helpers/ui_helper.dart';
import '../widgets/custom/custom_button.dart';

class AssignUserScreen extends StatefulWidget {
  const AssignUserScreen({super.key});

  @override
  State<AssignUserScreen> createState() => _AssignUserScreenState();
}

class _AssignUserScreenState extends State<AssignUserScreen>
    with ValidateMixin {
  String? firstname, lastname;

  GlobalKey<FormState>? guestFormKey;
  OverlayEntry? loader;

  @override
  void initState() {
    super.initState();
    loader = UIHelper.overlayLoader(context);
    guestFormKey = GlobalKey<FormState>();
  }

  void assignGuestUser(BuildContext context) async {
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
      } else {
        UIHelper.of(context).showSnackBar(tripModel.successMessage!);
        Navigator.of(context).pop();
      }

      loader!.remove();
    }
  }

  void refreshInviteCode() {
    UIHelper.of(context).showCustomAlertDialog(
      title: 'Refresh Invite Code',
      content: const Text('Are you sure you want to refresh the invite code?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Refresh'),
        ),
      ],
    );
  }

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
        title: const Text('Assign User'),
        titleTextStyle: TextStyle(
          color: Theme.of(context).primaryColor.computedLuminance(),
          fontSize: 24.0,
          fontWeight: FontWeight.w800,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              final String? text =
                  Provider.of<TripModel>(context, listen: false)
                      .selectedTrip!
                      .inviteCode;

              if (text != null) {
                Clipboard.setData(ClipboardData(text: text));
                UIHelper.of(context)
                    .showSnackBar('Invite code copied to clipboard');
              }
            },
            icon: Icon(
              Icons.copy_rounded,
              color: Theme.of(context).primaryColor.computedLuminance(),
            ),
          ),
          IconButton(
            onPressed: refreshInviteCode,
            icon: Icon(
              Icons.refresh_rounded,
              color: Theme.of(context).primaryColor.computedLuminance(),
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
                        Center(
                          child: Text(
                            "Share this code with the user to add them to this trip",
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
                        const SizedBox(height: 25.0),
                        Text(
                          'or create a guest account below',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Theme.of(context)
                                .primaryColor
                                .computedLuminance(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
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
                  Padding(
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
                          onTap: () => assignGuestUser(context),
                        ),
                      ],
                    ),
                  ),
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
