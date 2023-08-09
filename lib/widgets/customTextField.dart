import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  int maxLength;
  bool numbersOnly;

  CustomTextField({super.key, required this.controller, this.hintText = "", this.maxLength = 300, this.numbersOnly = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      keyboardType: numbersOnly ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        counter: Offstage(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      ),
    );
  }
}
