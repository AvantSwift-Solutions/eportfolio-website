import 'dart:ui';

import 'package:flutter/material.dart';

Color getColorFromNumber(int number) {
  List<Color> colorList = [
    Colors.orange.shade200,
    Colors.blue.shade200,
    Colors.green.shade200
    // Add more colors as needed
  ];

  // Use modulo to wrap around the colors if the number is too large
  final int index = number % colorList.length;

  return colorList[index];
}
