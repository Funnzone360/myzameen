import 'package:flutter/material.dart';

class AppUtils {
  static const String splashScreenBgImg =
      'https://images.unsplash.com/photo-1705893899659-64ab90038965?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxM3x8fGVufDB8fHx8fA%3D%3D';
  static Center customProgressIndicator() => const Center(
          child: CircularProgressIndicator(
        color: Colors.red,
        backgroundColor: Colors.blue,
      ));
  static TextStyle animationStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 15.0,
    );
  }
}

navigateTo(BuildContext context, Widget nextScreen) {
  Navigator.push(context, MaterialPageRoute(builder: (_) {
    return nextScreen;
  }));
}

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  // Constructor with required parameters
  const CustomText({
    required this.text,
    this.style,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
    );
  }
}
