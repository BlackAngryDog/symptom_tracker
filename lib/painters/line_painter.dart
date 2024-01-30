import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  final double width;

  LinePainter(this.width);

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.teal
      ..strokeWidth = 1;

    var paint2 = Paint()
      ..color = Colors.teal
      ..strokeWidth = 3;

    var w2 = size.width / 2;

    Offset center = Offset(w2, size.height / 2);
    Offset start = Offset(w2, size.height / 2);
    Offset end = Offset(w2 + (w2 * width), size.height / 2);
    canvas.drawCircle(center, 5, paint1);

    canvas.drawLine(Offset(w2, 0), Offset(w2, size.height), paint2);
    canvas.drawLine(Offset(w2, 2 + size.height / 2),
        Offset(width < 0 ? 0 : size.width, 2 + size.height / 2), paint1);

    canvas.drawLine(start, end, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
