import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripsplit/common/extensions/extensions.dart';
import 'package:tripsplit/mixins/validate_mixin.dart';

import '../../common/helpers/ui_helper.dart';
import '../../models/trip_model.dart';
import '../custom/custom_button.dart';
import '../custom/custom_text_form_field.dart';

class JoinTrip extends StatefulWidget {
  final Widget child;

  const JoinTrip({
    super.key,
    required this.child,
  });

  @override
  State<JoinTrip> createState() => _JoinTripState();
}

class _JoinTripState extends State<JoinTrip> with ValidateMixin {
  String? inviteCode;

  GlobalKey<FormState>? tripFormKey;
  OverlayEntry? loader;

  @override
  void initState() {
    super.initState();
    loader = UIHelper.overlayLoader(context);
    tripFormKey = GlobalKey<FormState>();
  }

  void createTrip(BuildContext context, TripModel tripModel) async {
    FocusScope.of(context).unfocus();
    if (tripFormKey!.currentState!.validate()) {
      tripFormKey!.currentState!.save();
      Overlay.of(context).insert(loader!);

      await tripModel.joinTrip(inviteCode!);

      if (tripModel.errorMessage != null) {
        UIHelper.of(context).showSnackBar(tripModel.errorMessage!, error: true);
      } else {
        UIHelper.of(context).showSnackBar(tripModel.successMessage!);
        Navigator.of(context).pop();
      }

      loader!.remove();
    }
  }

  void showJoinTrip(BuildContext context, TripModel tripModel) {
    UIHelper.of(context).showCustomBottomSheet(
      initialChildSize: 0.5,
      header: Container(
        padding: const EdgeInsets.only(top: 10.0, right: 15.0, left: 15.0),
        width: double.infinity,
        child: Column(
          children: [
            const Text(
              'Join a trip',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Enter the code to join a trip',
              style: TextStyle(
                fontSize: 14.0,
                color: Theme.of(context).dividerColor.darken(0.2),
              ),
            ),
          ],
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: tripFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                onSaved: (input) => inviteCode = input,
                validator: validateText,
                decoration:
                CustomTextFormField.buildDecoration(context).copyWith(
                  labelText: "Code",
                  hintText: 'Enter the trip code',
                  prefixIcon: Icon(
                    Icons.location_city_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      footer: Container(
        padding: const EdgeInsets.only(top: 10.0, right: 15.0, left: 15.0),
        width: double.infinity,
        child: CustomButton(
          onTap: () => createTrip(context, tripModel),
          text: 'Submit',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TripModel>(
      builder: (context, tripModel, _) {
        return GestureDetector(
          onTap: () => showJoinTrip(context, tripModel),
          child: widget.child,
        );
      }
    );
  }
}
