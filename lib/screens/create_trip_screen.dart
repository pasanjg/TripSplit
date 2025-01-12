import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/trip_model.dart';
import '../common/extensions/extensions.dart';
import '../common/helpers/ui_helper.dart';
import '../mixins/validate_mixin.dart';
import '../widgets/custom/custom_button.dart';
import '../widgets/custom/custom_datepicker.dart';
import '../widgets/custom/custom_text_form_field.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> with ValidateMixin {
  String? title;
  DateTime? startDate = DateTime.now(), endDate;
  DateTimeRange? dateRange;

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

  void createTrip(BuildContext context, TripModel tripModel) async {
    FocusScope.of(context).unfocus();
    if (tripFormKey!.currentState!.validate()) {
      tripFormKey!.currentState!.save();
      Overlay.of(context).insert(loader!);

      await tripModel.createTrip(
        title: title!,
        startDate: startDate!,
        endDate: endDate!,
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

  void onDateSelected(dynamic value) {
    if (value is DateTimeRange) {
      setState(() {
        dateRange = value;
        startDate = dateRange!.start;
        endDate = dateRange!.end;
        _startDateController.text = DateFormat('yyyy-MM-dd').format(startDate!);
        _endDateController.text = DateFormat('yyyy-MM-dd').format(endDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new trip'),
      ),
      body: Consumer<TripModel>(
        builder: (context, tripModel, _) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  const SizedBox(height: 30.0),
                  Container(
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
                  const SizedBox(height: 20.0),
                  Form(
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
                          dateRange: true,
                          initial: dateRange,
                          onDateSelected: onDateSelected,
                          child: CustomTextFormField(
                            enabled: false,
                            controller: _startDateController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.datetime,
                            validator: validateText,
                            decoration: CustomTextFormField.buildDecoration(context).copyWith(
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
                          dateRange: true,
                          initial: dateRange,
                          selectableDayPredicate: (DateTime day) {
                            return day.isAfter(startDate!.subtract(const Duration(days: 1)));
                          },
                          onDateSelected: onDateSelected,
                          child: CustomTextFormField(
                            enabled: false,
                            controller: _endDateController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.datetime,
                            validator: validateText,
                            decoration: CustomTextFormField.buildDecoration(context).copyWith(
                              labelText: "End Date",
                              prefixIcon: Icon(
                                Icons.calendar_today_rounded,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  CustomButton(
                    onTap: () => createTrip(context, tripModel),
                    text: 'Add New Trip',
                  ),
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

