import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  // Properties — customize each textfield from outside
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;        // for password fields
  final TextInputType keyboardType;
  final String? hintText;
  final IconData? prefixIcon;    // icon on left side

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.obscureText = false,           // default false
    this.keyboardType = TextInputType.text, // default normal keyboard
    this.hintText,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}