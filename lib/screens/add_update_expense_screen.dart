import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../common/constants/constants.dart';
import '../common/extensions/extensions.dart';
import '../mixins/validate_mixin.dart';
import '../models/trip_model.dart';
import '../widgets/custom/custom_button.dart';
import '../widgets/custom/custom_datepicker.dart';
import '../widgets/custom/custom_text_form_field.dart';
import '../widgets/image_uploader.dart';
import '../common/helpers/ui_helper.dart';
import '../entities/expense.dart';
import '../entities/user.dart';
import '../models/user_model.dart';

class AddUpdateExpenseScreen extends StatefulWidget {
  final Expense? expense;

  const AddUpdateExpenseScreen({super.key, this.expense});

  @override
  State<AddUpdateExpenseScreen> createState() => _AddUpdateExpenseScreenState();
}

class _AddUpdateExpenseScreenState extends State<AddUpdateExpenseScreen> with ValidateMixin {
  String title = '', category = '', payeeId = '';
  String? receiptUrl;
  double amount = 0.0;
  DateTime date = DateTime.now();

  GlobalKey<FormState>? expenseFormKey;
  OverlayEntry? loader;

  final TextEditingController _titleController = TextEditingController();
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
      initExpense();
    });
  }

  @override
  void dispose() {
    _amountFocusNode.dispose();
    _titleController.dispose();
    _dateController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void loadTripUsers() async {
    Overlay.of(context).insert(loader!);
    final tripModel = Provider.of<TripModel>(context, listen: false);
    await tripModel.selectedTrip!.loadUsers();
    loader!.remove();
  }

  void initExpense() {
    if (widget.expense != null) {
      final expense = widget.expense!;

      title = expense.title!;
      category = expense.category!;
      amount = expense.amount!;
      date = expense.date!;
      payeeId = expense.userRef!.id;
      receiptUrl = expense.receiptUrl;

      _titleController.text = title;
      _amountController.text = amount.toString();
      _dateController.text = DateFormat('yyyy-MM-dd').format(date);

      setState(() {});
    }
  }

  void addOrUpdateExpense(BuildContext context, TripModel tripModel) async {
    FocusScope.of(context).unfocus();
    if (expenseFormKey!.currentState!.validate()) {
      expenseFormKey!.currentState!.save();
      Overlay.of(context).insert(loader!);

      await tripModel.addOrUpdateExpense(
        id: widget.expense?.id,
        title: title,
        category: category,
        date: date,
        amount: amount,
        userId: payeeId,
        receiptUrl: receiptUrl,
      );

      if (!context.mounted) return;

      if (tripModel.errorMessage != null) {
        UIHelper.of(context).showSnackBar(tripModel.errorMessage!, error: true);
      } else if (tripModel.successMessage != null) {
        UIHelper.of(context).showSnackBar(tripModel.successMessage!);
        Navigator.of(context).popUntil((route) => route.isFirst);
      }

      loader!.remove();
    }
  }

  void showDeleteConfirmation() {
    UIHelper.of(context).showCustomAlertDialog(
      title: 'Delete Record',
      content: const Text('Are you sure you want to delete this record?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: deleteExpense,
          child: const Text('Delete'),
        ),
      ],
    );
  }

  Future<void> deleteExpense() async {
    Navigator.of(context, rootNavigator: true).pop();

    Overlay.of(context).insert(loader!);
    final tripModel = Provider.of<TripModel>(context, listen: false);

    await tripModel.deleteExpense(widget.expense!.id!);

    if (!context.mounted) return;

    if (tripModel.errorMessage != null) {
      UIHelper.of(context).showSnackBar(
        tripModel.errorMessage!,
        error: true,
      );
    } else if (tripModel.successMessage != null) {
      UIHelper.of(context).showSnackBar(tripModel.successMessage!);
      Navigator.of(context).popUntil((route) => route.isFirst);
    }

    loader!.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          widget.expense != null ? 'Update Expense' : 'Add Expense',
          style: TextStyle(
            color: Theme.of(context).primaryColor.contrastColor(),
          ),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor.contrastColor()),
        actions: [
          if (widget.expense != null)
            IconButton(
              onPressed: showDeleteConfirmation,
              icon: const Icon(Icons.delete_forever_rounded),
            ),
        ],
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
                      color: Theme.of(context).primaryColor.contrastColor().withOpacity(0.7),
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
                          color: Theme.of(context).primaryColor.contrastColor().withOpacity(amount == 0.0 ? 0.5 : 1.0),
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
                          controller: _titleController,
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
                            suffixIcon: _amountController.text != ""
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        amount = 0.0;
                                        _amountController.clear();
                                      });
                                    },
                                    icon: Icon(
                                      Icons.clear_rounded,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: CustomTextFormField.buildDecoration(context).copyWith(
                                prefixIcon: Icon(
                                  Category.getCategory(category).icon,
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
                          selectableDayPredicate: (DateTime day) {
                            return day.isBefore(DateTime.now().add(const Duration(days: 1)));
                          },
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
                        ImageUploader(
                          imageUrl: receiptUrl,
                          onUpload: (String? imageUrl) {
                            setState(() {
                              receiptUrl = imageUrl;
                            });
                          },
                          child: Container(
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
                                  Icon(
                                    Icons.receipt_rounded,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    receiptUrl == null
                                        ? 'Upload Receipt'
                                        : 'Replace Receipt',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        CustomButton(
                          onTap: () => addOrUpdateExpense(context, tripModel),
                          text: widget.expense != null
                              ? 'Update Expense'
                              : 'Add Expense',
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
