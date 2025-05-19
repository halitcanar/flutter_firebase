import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {

  final VoidCallback onPressed;
  final String buttonText;
  final Color textColor;

  const CustomTextButton({
    super.key, 
    required this.onPressed, 
    required this.buttonText, 
    this.textColor = Colors.white
    });
  // Constructor with default values for textColor and buttonText

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
          onPressed: onPressed,
          child: Text(buttonText, style: TextStyle(color: textColor)),
        ),
    );
  } 
}