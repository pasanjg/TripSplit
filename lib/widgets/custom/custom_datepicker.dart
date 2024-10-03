import 'package:flutter/material.dart';

class CustomDatePicker extends StatefulWidget {
  final Widget child;
  final DateTime? initialDate;
  final Function(DateTime? date) onDateSelected;
  final bool Function(DateTime day)? selectableDayPredicate;

  const CustomDatePicker({
    super.key,
    this.initialDate,
    required this.onDateSelected,
    required this.child,
    this.selectableDayPredicate,
  });

  @override
  CustomDatePickerState createState() => CustomDatePickerState();
}

class CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _date;
  late bool Function(DateTime day) _selectableDayPredicate;

  @override
  initState() {
    super.initState();
    _date = widget.initialDate;
    _selectableDayPredicate = widget.selectableDayPredicate ?? ((_) => true);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 100),
      selectableDayPredicate: _selectableDayPredicate,
    );

    if (pickedDate != null) {
      setState(() {
        _date = pickedDate;
      });

      widget.onDateSelected(_date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: widget.child,
    );
  }
}
