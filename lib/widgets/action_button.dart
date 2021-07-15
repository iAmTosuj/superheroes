import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ActionButton({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Color(0xFF00BCD4)),
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
