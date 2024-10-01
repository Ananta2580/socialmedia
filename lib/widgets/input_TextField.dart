import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPassword;
  final String hintText;
  final TextInputType textInputType;
  const InputTextField({super.key,
    required this.textEditingController,
    required this.textInputType,
    required this.hintText,
    required this.isPassword
  });

  @override
  Widget build(BuildContext context) {
    final inputTextBorder = OutlineInputBorder(
        borderSide: Divider.createBorderSide(context)
    );
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputTextBorder,
        focusedBorder: inputTextBorder,
        enabledBorder: inputTextBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8.0),
      ),
      keyboardType: textInputType,
      obscureText: isPassword,
    );
  }
}
