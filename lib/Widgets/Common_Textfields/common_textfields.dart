import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final int? maxLength;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final Function? onTap;
  final bool? readOnly;
  final Widget? preFixIcon;
  final Widget? sufFixIcon;
  final TextInputAction? inputAction;
  final String? labelText;
  final int? maxLine;

  const CommonTextField({
    super.key,
    required this.keyboardType,
    required this.controller,
    required this.hintText,
    this.maxLength,
    this.obscureText,
    this.validator,
    this.readOnly,
    this.preFixIcon,
    this.sufFixIcon,
    this.onTap,
    this.labelText,
    this.inputAction,
    this.maxLine,
  });

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: validator,
      maxLines: maxLine,
      readOnly: readOnly ?? false,
      obscureText: obscureText ?? false,
      textInputAction: inputAction,
      onTap: () {
        if ((readOnly ?? false) && onTap != null) {
          onTap!();
        }
      },
      decoration: InputDecoration(
        prefixIcon: preFixIcon,
        suffixIcon: sufFixIcon,
        hintText: hintText,
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        border: InputBorder.none,
      ),
    );
  }
}