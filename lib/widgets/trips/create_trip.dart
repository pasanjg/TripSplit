import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripsplit/common/extensions/extensions.dart';
import 'package:tripsplit/mixins/validate_mixin.dart';

import '../../common/helpers/ui_helper.dart';
import '../../models/trip_model.dart';
import '../custom/custom_button.dart';
import '../custom/custom_datepicker.dart';
import '../custom/custom_text_form_field.dart';

class CreateTrip extends StatefulWidget {
  final TripModel tripModel;
  final Widget child;

  const CreateTrip({
    super.key,
    required this.child,
    required this.tripModel,
  });

  @override
  State<CreateTrip> createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> with ValidateMixin {
  String? title;
  DateTime? startDate = DateTime.now(), endDate;

  GlobalKey<FormState>? tripFormKey;
  OverlayEntry? loader;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loader = UIHelper.overlayLoader(context);
    tripFormKey = GlobalKey<FormState>();
  }

  void createTrip(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (tripFormKey!.currentState!.validate()) {
      tripFormKey!.currentState!.save();
      Overlay.of(context).insert(loader!);

      await widget.tripModel.createTrip(
        title: title!,
        startDate: startDate!,
        endDate: endDate!,
      );

      Navigator.of(context).pop();
      loader!.remove();
    }
  }

  void showAddNew(BuildContext context, TripModel tripModel) {
    UIHelper.of(context).showCustomBottomSheet(
      initialChildSize: 0.5,
      header: Container(
        padding: const EdgeInsets.only(top: 10.0, right: 15.0, left: 15.0),
        width: double.infinity,
        child: Column(
          children: [
            const Text(
              'Add New Trip',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Create a new trip to start logging expenses',
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
                onSaved: (input) => title = input,
                validator: validateText,
                decoration:
                    CustomTextFormField.buildDecoration(context).copyWith(
                  labelText: "Title",
                  hintText: 'Awesome Trip',
                  prefixIcon: Icon(
                    Icons.location_city_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              CustomDatePicker(
                onDateSelected: (DateTime? date) {
                  setState(() {
                    startDate = date;
                    _startDateController.text =
                        DateFormat('yyyy-MM-dd').format(startDate!);
                  });
                },
                child: CustomTextFormField(
                  enabled: false,
                  controller: _startDateController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.datetime,
                  validator: validateText,
                  decoration:
                      CustomTextFormField.buildDecoration(context).copyWith(
                    labelText: "Start Date",
                    prefixIcon: Icon(
                      Icons.calendar_today_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              CustomDatePicker(
                initialDate: startDate,
                onDateSelected: (DateTime? date) {
                  setState(() {
                    endDate = date;
                    _endDateController.text =
                        DateFormat('yyyy-MM-dd').format(endDate!);
                  });
                },
                child: CustomTextFormField(
                  enabled: false,
                  controller: _endDateController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.datetime,
                  decoration:
                      CustomTextFormField.buildDecoration(context).copyWith(
                    labelText: "End Date",
                    prefixIcon: Icon(
                      Icons.calendar_today_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              Text(_buildSelectedDateDiff()),
            ],
          ),
        ),
      ),
      footer: Container(
        padding: const EdgeInsets.only(top: 10.0, right: 15.0, left: 15.0),
        width: double.infinity,
        child: CustomButton(
          onTap: () => createTrip(context),
          text: 'Add New Trip',
        ),
      ),
    );
  }

  String _buildSelectedDateDiff() {
    if (startDate == endDate) {
      return "Selected 1 day";
    }

    if (startDate != null && endDate != null) {
      return "Selected ${endDate?.difference(startDate!).inDays} days";
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showAddNew(context, widget.tripModel),
      child: widget.child,
    );
  }
}
