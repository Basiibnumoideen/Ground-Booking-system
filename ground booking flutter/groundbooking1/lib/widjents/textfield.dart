import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final prefixIcon;
  final readonly;
  final obsecure;
  final suffix;
  final enableSuggession;
  const CustomTextField({
    Key? key,
    this.hintText,
    this.controller,
    this.labelText,
    this.onSaved,
    this.validator,
    this.prefixIcon,
    this.readonly,
    this.obsecure,
    this.suffix,
    this.enableSuggession,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enableSuggestions: enableSuggession ?? false,
      obscureText: obsecure ?? false,
      readOnly: readonly ?? false,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: hintText ?? '',
        labelText: labelText ?? '',
        prefixIcon: prefixIcon,
        suffix: suffix,
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }
}
