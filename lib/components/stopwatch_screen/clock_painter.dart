import 'dart:math';

import 'package:flutter/material.dart';

class ClockPainter extends CustomPainter {
  final bool isDarkTheme;

  final Duration elapsed;

  ClockPainter(this.elapsed, this.isDarkTheme);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final tickPaint = Paint()
      ..color = isDarkTheme ? Colors.white : Colors.black
      ..strokeWidth = 2;

    // Draw the ticks and numbers
    for (int i = 0; i < 60; i++) {
      final angle = i * pi / 30;
      final tickLength = i % 5 == 0 ? 10.0 : 5.0;
      final startOffset = Offset(
        center.dx + (radius - tickLength) * cos(angle),
        center.dy + (radius - tickLength) * sin(angle),
      );
      final endOffset = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      canvas.drawLine(startOffset, endOffset, tickPaint);

      // Draw the numbers
      if (i % 5 == 0) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: '${i == 0 ? 60 : i}',
            style: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        final numberAngle = i * pi / 30 - pi / 2;
        final numberOffset = Offset(
          center.dx + (radius - 25) * cos(numberAngle) - textPainter.width / 2,
          center.dy + (radius - 25) * sin(numberAngle) - textPainter.height / 2,
        );
        textPainter.paint(canvas, numberOffset);
      }
    }

    final secondsHandLength = radius * 0.8;
    final secondsHandPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2;

    final secondsAngle = (elapsed.inMilliseconds % 60000) * 2 * pi / 60000;
    final secondsHandOffset = Offset(
      center.dx + secondsHandLength * cos(secondsAngle - pi / 2),
      center.dy + secondsHandLength * sin(secondsAngle - pi / 2),
    );

    canvas.drawLine(center, secondsHandOffset, secondsHandPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
