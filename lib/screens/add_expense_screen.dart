import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tripsplit/common/constants/constants.dart';
import 'package:tripsplit/common/extensions/extensions.dart';
import 'package:tripsplit/mixins/validate_mixin.dart';
import 'package:tripsplit/models/trip_model.dart';
import 'package:tripsplit/widgets/custom/custom_button.dart';
import 'package:tripsplit/widgets/custom/custom_datepicker.dart';
import 'package:tripsplit/widgets/custom/custom_text_form_field.dart';

import '../common/helpers/ui_helper.dart';
import '../entities/user.dart';
import '../models/user_model.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> with ValidateMixin {
  late String title, category, payeeId;
  double amount = 0.0;
  DateTime date = DateTime.now();

  GlobalKey<FormState>? expenseFormKey;
  OverlayEntry? loader;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    loader = UIHelper.overlayLoader(context);
    payeeId = Provider.of<UserModel>(context, listen: false).user!.id!;
    category = Category.categories.first.name;
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    expenseFormKey = GlobalKey<FormState>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadTripUsers();
    });
  }

  @override
  void dispose() {
    _amountFocusNode.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void loadTripUsers() async {
    Overlay.of(context).insert(loader!);
    final tripModel = Provider.of<TripModel>(context, listen: false);
    await tripModel.selectedTrip!.loadUsers();
    loader!.remove();
  }

  void addExpense(BuildContext context, TripModel tripModel) async {
    FocusScope.of(context).unfocus();
    if (expenseFormKey!.currentState!.validate()) {
      expenseFormKey!.currentState!.save();
      Overlay.of(context).insert(loader!);

      await tripModel.addExpense(
        title: title,
        category: category,
        date: date,
        amount: amount,
        userId: payeeId,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor.computedLuminance(),
          ),
        ),
        title: const Text('Add Expense'),
        titleTextStyle: TextStyle(
          color: Theme.of(context).primaryColor.computedLuminance(),
          fontSize: 24.0,
          fontWeight: FontWeight.w800,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 15.0,
              ),
              color: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "LKR",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor.computedLuminance().withOpacity(0.7),
                      fontSize: 28.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _amountFocusNode.requestFocus();
                      },
                      child: Text(
                        NumberFormat.currency(
                          symbol: '',
                          decimalDigits: 2,
                        ).format(amount),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor.computedLuminance().withOpacity(amount == 0.0 ? 0.5 : 1.0),
                          fontSize: 28.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Consumer<TripModel>(
                builder: (context, tripModel, _) {
                  return Form(
                    key: expenseFormKey,
                    child: Column(
                      children: [
                        Text(
                          "Add your expenses to ${tripModel.selectedTrip!.title}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        CustomTextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          onSaved: (input) => title = input!,
                          validator: validateText,
                          decoration: CustomTextFormField.buildDecoration(context)
                              .copyWith(
                            prefixIcon: Icon(
                              Icons.description,
                              color: Theme.of(context).primaryColor,
                            ),
                            labelText: 'Title',
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        CustomTextFormField(
                          focusNode: _amountFocusNode,
                          controller: _amountController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          validator: validateText,
                          onChanged: (input) {
                            setState(() {
                              if (input == null || input.isEmpty) {
                                amount = 0.0;
                              } else {
                                amount = double.parse(input);
                              }
                            });
                          },
                          decoration: CustomTextFormField.buildDecoration(context)
                              .copyWith(
                            prefixIcon: Icon(
                              Icons.money_rounded,
                              color: Theme.of(context).primaryColor,
                            ),
                            labelText: 'Amount',
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: CustomTextFormField.buildDecoration(context).copyWith(
                                prefixIcon: Icon(
                                  Icons.category_rounded,
                                  color: Theme.of(context).primaryColor,
                                ),
                                labelText: 'Category',
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: const Text('Select Category'),
                                  value: category,
                                  isExpanded: true,
                                  isDense: true,
                                  onChanged: (String? selectedValue) {
                                    setState(() {
                                      category = selectedValue!;
                                      state.didChange(selectedValue.toString());
                                    });
                                  },
                                  items: Category.categories.map((Category category) {
                                    return DropdownMenuItem<String>(
                                      value: category.name,
                                      child: Text(category.displayName),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 15.0),
                        CustomDatePicker(
                          onDateSelected: (DateTime? value) {
                            setState(() {
                              setState(() {
                                date = value!;
                                _dateController.text = DateFormat('yyyy-MM-dd').format(date);
                              });
                            });
                          },
                          child: CustomTextFormField(
                            enabled: false,
                            controller: _dateController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.datetime,
                            decoration: CustomTextFormField.buildDecoration(context)
                                .copyWith(
                              prefixIcon: Icon(
                                Icons.calendar_today,
                                color: Theme.of(context).primaryColor,
                              ),
                              labelText: 'Date',
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Consumer<UserModel>(
                          builder: (context, userModel, _) {
                            return FormField<String>(
                              builder: (FormFieldState<String> state) {
                                return InputDecorator(
                                  decoration: CustomTextFormField.buildDecoration(context).copyWith(
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    labelText: 'Payee',
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      hint: const Text('Select Payee'),
                                      value: payeeId,
                                      isExpanded: true,
                                      isDense: true,
                                      onChanged: (String? selectedValue) {
                                        setState(() {
                                          payeeId = selectedValue!;
                                          state.didChange(selectedValue);
                                        });
                                      },
                                      items: tripModel.selectedTrip!.users.map((User user) {
                                        return DropdownMenuItem<String>(
                                          value: user.id,
                                          child: Text("${user.fullName} ${user.mySelf ? '(You)' : ''}"),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 15.0),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 10.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.receipt_rounded, color: Theme.of(context).primaryColor),
                                const SizedBox(width: 8.0),
                                Text(
                                  'Upload Receipt',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        CustomButton(
                          onTap: () => addExpense(context, tripModel),
                          text: 'Add Expense',
                        ),
                        const SizedBox(height: 15.0),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}