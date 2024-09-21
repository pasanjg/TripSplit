import 'package:flutter/material.dart';

class CustomDatePicker extends StatefulWidget {
  final Widget child;
  final DateTime? initialDate;
  final Function(DateTime? date) onDateSelected;

  const CustomDatePicker({
    super.key,
    this.initialDate,
    required this.onDateSelected,
    required this.child,
  });

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _date;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 100),
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
