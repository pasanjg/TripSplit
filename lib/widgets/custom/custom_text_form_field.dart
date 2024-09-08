import 'package:flutter/material.dart';

import '../../common/extensions/extensions.dart';

class CustomTextFormField extends StatefulWidget {
  final bool isPassword;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final InputDecoration? decoration;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const CustomTextFormField({
    super.key,
    this.isPassword = false,
    this.focusNode,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.decoration,
    this.validator,
    this.onSaved,
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
      fillColor: Theme.of(context).colorScheme.secondary.lighten(0.5),
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
          color: Theme.of(context).colorScheme.tertiary.withOpacity(0.4),
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
      focusNode: widget.focusNode,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onSaved: widget.onSaved,
      obscureText: widget.isPassword && _hidePassword,
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
