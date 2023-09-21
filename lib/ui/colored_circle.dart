import 'dart:ui';

import 'package:flutter/cupertino.dart';

class ColoredCircle extends StatelessWidget {
  final Color selectedColor;

  const ColoredCircle({super.key, required this.selectedColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.0, // Define the width of the circle
      height: 28.0, // Define the height of the circle
      decoration: BoxDecoration(
        shape: BoxShape.circle, // This makes the container a circle
        color: selectedColor, // Specify the color you want
      ),
    );
  }
}
