import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {required this.backColor,
      required this.TextColor,
      required this.onPressed,
      required this.text});

  final Color backColor;
  final Color TextColor;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        color: backColor,
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: MaterialButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 19,
              color: TextColor,
            ),
          ),
        ),
      ),
    );
  }
}
