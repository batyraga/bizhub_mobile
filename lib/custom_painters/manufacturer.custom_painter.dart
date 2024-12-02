import 'package:flutter/material.dart';

class ManufacturerCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.5000000, 0);
    path_0.lineTo(size.width * 0.6368100, size.height * 0.1241230);
    path_0.lineTo(size.width * 0.8213950, size.height * 0.1169780);
    path_0.lineTo(size.width * 0.8464100, size.height * 0.3000000);
    path_0.lineTo(size.width * 0.9924050, size.height * 0.4131760);
    path_0.lineTo(size.width * 0.8939250, size.height * 0.5694600);
    path_0.lineTo(size.width * 0.9330150, size.height * 0.7500000);
    path_0.lineTo(size.width * 0.7571150, size.height * 0.8064200);
    path_0.lineTo(size.width * 0.6710100, size.height * 0.9698450);
    path_0.lineTo(size.width * 0.5000000, size.height * 0.9000000);
    path_0.lineTo(size.width * 0.3289900, size.height * 0.9698450);
    path_0.lineTo(size.width * 0.2428850, size.height * 0.8064200);
    path_0.lineTo(size.width * 0.06698750, size.height * 0.7500000);
    path_0.lineTo(size.width * 0.1060770, size.height * 0.5694600);
    path_0.lineTo(size.width * 0.007596100, size.height * 0.4131760);
    path_0.lineTo(size.width * 0.1535900, size.height * 0.3000000);
    path_0.lineTo(size.width * 0.1786060, size.height * 0.1169780);
    path_0.lineTo(size.width * 0.3631920, size.height * 0.1241230);
    path_0.lineTo(size.width * 0.5000000, 0);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xff2B94EB).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.3000000, size.height * 0.5000000);
    path_1.lineTo(size.width * 0.4500000, size.height * 0.6250000);
    path_1.lineTo(size.width * 0.7000000, size.height * 0.3500000);

    Paint paint1Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07500000;
    paint1Stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_1, paint1Stroke);

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = const Color(0xff000000).withOpacity(0.0);
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
