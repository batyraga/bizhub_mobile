import 'package:flutter/material.dart';

class DiscountShapeCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.9876744, size.height * 0.5235593);
    path_0.cubicTo(
        size.width * 1.006000,
        size.height * 0.6223481,
        size.width * 0.9654128,
        size.height * 0.7238926,
        size.width * 0.8970179,
        size.height * 0.7503630);
    path_0.lineTo(size.width * 0.3291308, size.height * 0.9701556);
    path_0.cubicTo(
        size.width * 0.2962872,
        size.height * 0.9828704,
        size.width * 0.2612923,
        size.height * 0.9762148,
        size.width * 0.2318456,
        size.height * 0.9516556);
    path_0.lineTo(size.width * 0.07482692, size.height * 0.8207111);
    path_0.cubicTo(
        size.width * 0.01350746,
        size.height * 0.7695741,
        size.width * -0.007502051,
        size.height * 0.6563148,
        size.width * 0.02790077,
        size.height * 0.5677444);
    path_0.lineTo(size.width * 0.1185556, size.height * 0.3409389);
    path_0.cubicTo(
        size.width * 0.1355567,
        size.height * 0.2984048,
        size.width * 0.1635590,
        size.height * 0.2673681,
        size.width * 0.1964026,
        size.height * 0.2546563);
    path_0.lineTo(size.width * 0.7642897, size.height * 0.03486211);
    path_0.cubicTo(
        size.width * 0.8326846,
        size.height * 0.008391407,
        size.width * 0.9029846,
        size.height * 0.06701778,
        size.width * 0.9213103,
        size.height * 0.1658078);
    path_0.lineTo(size.width * 0.9876744, size.height * 0.5235593);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xffFF0000).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
