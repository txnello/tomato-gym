import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  VoidCallback onTap;

  String text;
  Color textColor;
  Color buttonColor;
  double borderRadius;
  double verticalPadding;
  double horizontalPadding;
  double fontSize;

  CustomButton({super.key, required this.onTap, required this.text, this.textColor = Colors.white, this.buttonColor = Colors.red, this.borderRadius = 10, this.fontSize = 18, this.horizontalPadding = 15, this.verticalPadding = 10});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(borderRadius)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: fontSize),
          ),
        ),
      ),
    );
  }
}
