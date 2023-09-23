import 'package:flutter/cupertino.dart';

class DashedLineVerticalPainter extends CustomPainter {
  final Color selectedColor;

  DashedLineVerticalPainter({required this.selectedColor});

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 8, dashSpace = 5, startY = 0;
    final paint = Paint()
      ..color = selectedColor
      ..strokeWidth = 1;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
