import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  TextEditingController controller;
  String hintText;

  CustomTextField({super.key, required this.controller, this.hintText = ""});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      ),
    );
  }
}
