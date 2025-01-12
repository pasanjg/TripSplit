import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomTextFormField extends StatefulWidget {
  final String? initialValue;
  final bool isPassword;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final InputDecoration? decoration;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final bool enabled;

  const CustomTextFormField({
    super.key,
    this.initialValue,
    this.isPassword = false,
    this.focusNode,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.decoration,
    this.inputFormatters = const [],
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.onSaved,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();

  static InputDecoration buildDecoration(BuildContext context) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 10.0,
      ),
      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
      hintStyle: TextStyle(
        fontSize: 15.0,
        color: Theme.of(context).hintColor,
      ),
      errorStyle: TextStyle(
        color: Theme.of(context).colorScheme.error,
        fontSize: 13.0,
      ),
      filled: true,
      fillColor: Colors.grey.withOpacity(0.1),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor.withOpacity(0.4),
          width: 2.0,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.tertiary.withOpacity(0.4),
          width: 2.0,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 2.0,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
          width: 2.0,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
    );
  }
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      focusNode: widget.focusNode,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      autovalidateMode: widget.autovalidateMode,
      validator: widget.validator,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      obscureText: widget.isPassword && _hidePassword,
      enabled: widget.enabled,
      decoration: CustomTextFormField.buildDecoration(context).copyWith(
        suffixIcon: widget.isPassword
            ? Material(
                color: Colors.transparent,
                child: IconButton(
                  splashRadius: 20.0,
                  onPressed: () {
                    setState(() {
                      _hidePassword = !_hidePassword;
                    });
                  },
                  color: Theme.of(context).focusColor,
                  icon: Icon(
                    _hidePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              )
            : widget.decoration?.suffixIcon,
        labelText: widget.decoration?.labelText,
        hintText: widget.decoration?.hintText,
        prefixIcon: widget.decoration?.prefixIcon,
      ),
    );
  }
}
