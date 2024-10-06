import 'package:flutter/material.dart';

class CustomDatePicker extends StatefulWidget {
  final bool dateRange;
  final dynamic initial; // Can be DateTime or DateTimeRange
  final Function(dynamic date) onDateSelected;
  final bool Function(DateTime day)? selectableDayPredicate;
  final Widget child;

  const CustomDatePicker({
    super.key,
    this.initial,
    required this.onDateSelected,
    required this.child,
    this.selectableDayPredicate,
    this.dateRange = false,
  });

  @override
  CustomDatePickerState createState() => CustomDatePickerState();
}

class CustomDatePickerState extends State<CustomDatePicker> {
  dynamic _selectedDate;
  late bool Function(DateTime day) _selectableDayPredicate;

  @override
  void initState() {
    super.initState();
    _updateSelectedDate();
    _selectableDayPredicate = widget.selectableDayPredicate ?? ((_) => true);
  }

  @override
  void didUpdateWidget(CustomDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initial != oldWidget.initial) {
      _updateSelectedDate();
    }
  }

  void _updateSelectedDate() {
    if (widget.dateRange) {
      if (widget.initial is DateTimeRange) {
        _selectedDate = widget.initial;
      } else if (widget.initial is DateTime) {
        _selectedDate = DateTimeRange(
          start: widget.initial,
          end: widget.initial.add(const Duration(days: 7)),
        );
      } else {
        _selectedDate = DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(days: 7)),
        );
      }
    } else {
      _selectedDate = widget.initial is DateTime
          ? widget.initial
          : DateTime.now();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    if (widget.dateRange) {
      final DateTimeRange? pickedDateRange = await showDateRangePicker(
        context: context,
        initialDateRange: _selectedDate is DateTimeRange
            ? _selectedDate
            : DateTimeRange(
          start: _selectedDate ?? DateTime.now(),
          end: _selectedDate ?? DateTime.now(),
        ),
        firstDate: DateTime(DateTime.now().year - 100),
        lastDate: DateTime(DateTime.now().year + 100),
        saveText: 'SAVE',
      );

      if (pickedDateRange != null) {
        setState(() {
          _selectedDate = pickedDateRange;
        });
        widget.onDateSelected(_selectedDate);
      }
    } else {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate is DateTime ? _selectedDate : DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 100),
        lastDate: DateTime(DateTime.now().year + 100),
        selectableDayPredicate: _selectableDayPredicate,
      );

      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate;
        });
        widget.onDateSelected(_selectedDate);
      }
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
