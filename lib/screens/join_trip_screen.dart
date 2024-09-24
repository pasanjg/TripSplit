import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripsplit/common/extensions/extensions.dart';

import '../common/helpers/ui_helper.dart';
import '../mixins/validate_mixin.dart';
import '../models/trip_model.dart';
import '../widgets/custom/custom_button.dart';
import '../widgets/custom/custom_text_form_field.dart';

class JoinTripScreen extends StatefulWidget {
  const JoinTripScreen({super.key});

  @override
  State<JoinTripScreen> createState() => _JoinTripScreenState();
}

class _JoinTripScreenState extends State<JoinTripScreen> with ValidateMixin {
  String? inviteCode;

  GlobalKey<FormState>? joinFormKey;
  OverlayEntry? loader;

  @override
  void initState() {
    super.initState();
    loader = UIHelper.overlayLoader(context);
    joinFormKey = GlobalKey<FormState>();
  }

  void joinTrip(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (joinFormKey!.currentState!.validate()) {
      joinFormKey!.currentState!.save();
      Overlay.of(context).insert(loader!);

      final tripModel = Provider.of<TripModel>(context, listen: false);
      await tripModel.joinTrip(inviteCode!);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor.computedLuminance(),
          ),
        ),
        title: const Text('Join Trip'),
        titleTextStyle: TextStyle(
          color: Theme.of(context).primaryColor.computedLuminance(),
          fontSize: 24.0,
          fontWeight: FontWeight.w800,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Center(
          child: Form(
            key: joinFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                const Center(
                  child: Text(
                    'Enter the code',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Center(
                  child: Text(
                    'Enter the code shared by the trip owner to join the trip',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Theme.of(context).dividerColor.darken(0.2),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  onSaved: (input) => inviteCode = input,
                  validator: validateText,
                  decoration: InputDecoration(
                    labelText: 'Trip Code',
                    hintText: 'Enter the trip code',
                    prefixIcon: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 25.0),
                CustomButton(
                  text: 'Join Trip',
                  onTap: () => joinTrip(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
