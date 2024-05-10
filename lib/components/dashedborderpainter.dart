import 'package:flutter/material.dart';

import '../themes/theme.dart';

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = MyAppColors.primaryColor
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    const double dashWidth = 60;
    double startX = 0;

    canvas.drawLine(
        Offset(startX - 5, 0), Offset(startX + dashWidth, 0), paint);
    canvas.drawLine(
        Offset(size.width - dashWidth, 0), Offset(size.width + 5, 0), paint);
    canvas.drawLine(
        Offset(startX - 5, size.height), Offset(startX + dashWidth, size.height), paint);
    canvas.drawLine(
        Offset(size.width - dashWidth, size.height), Offset(size.width + 5, size.height), paint);


    double startY = 0;
    canvas.drawLine(
        Offset(0, startY), Offset(0, startY + dashWidth), paint);
    canvas.drawLine(
        Offset(0, size.height - dashWidth), Offset(0, size.height), paint);
    canvas.drawLine(
        Offset(size.width, startY), Offset(size.width, startY + dashWidth), paint);
    canvas.drawLine(
        Offset(size.width, size.height - dashWidth), Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}