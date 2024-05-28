import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? title;
  final void Function()? onPressed;

  const CustomButton({
    super.key,
    this.title,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 70,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Color(0xFFC8291D),
      onPressed: onPressed,
      child: Center(
        child: Text(title.toString()),
      ),
    );
  }
}
