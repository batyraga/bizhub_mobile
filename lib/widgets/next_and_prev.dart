import 'package:flutter/material.dart';

class NextButton extends StatefulWidget {
  final String title;
  final void Function()? onTap;
  const NextButton({super.key, this.onTap, required this.title});

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: CustomPaint(
        painter: RightShapeCustomPainter(),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2 - 30,
          height: 50,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 24,
                ),
                const Icon(
                  Icons.chevron_right_outlined,
                  size: 26.0,
                ),
              ]),
        ),
      ),
    );
  }
}

class PrevButton extends StatefulWidget {
  final String title;
  final void Function()? onTap;
  const PrevButton({super.key, this.onTap, required this.title});

  @override
  State<PrevButton> createState() => _PrevButtonState();
}

class _PrevButtonState extends State<PrevButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: CustomPaint(
        painter: LeftShapeCustomPainter(),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2 - 30,
          height: 50,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.chevron_left_outlined,
                  size: 26.0,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 22,
                ),
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18.0),
                )
              ]),
        ),
      ),
    );
  }
}

class LeftShapeCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.9932432, size.height * 0.2000000);
    path_0.cubicTo(
        size.width * 0.9932432,
        size.height * 0.1005888,
        size.width * 0.9660203,
        size.height * 0.02000000,
        size.width * 0.9324324,
        size.height * 0.02000000);
    path_0.lineTo(size.width * 0.1540966, size.height * 0.02000000);
    path_0.cubicTo(
        size.width * 0.1356230,
        size.height * 0.02000000,
        size.width * 0.1181514,
        size.height * 0.04485620,
        size.width * 0.1066108,
        size.height * 0.08755480);
    path_0.lineTo(size.width * 0.02552993, size.height * 0.3875540);
    path_0.cubicTo(
        size.width * 0.007762500,
        size.height * 0.4532940,
        size.width * 0.007762500,
        size.height * 0.5467060,
        size.width * 0.02552993,
        size.height * 0.6124460);
    path_0.lineTo(size.width * 0.1066108, size.height * 0.9124460);
    path_0.cubicTo(
        size.width * 0.1181514,
        size.height * 0.9551440,
        size.width * 0.1356230,
        size.height * 0.9800000,
        size.width * 0.1540966,
        size.height * 0.9800000);
    path_0.lineTo(size.width * 0.9324324, size.height * 0.9800000);
    path_0.cubicTo(
        size.width * 0.9660203,
        size.height * 0.9800000,
        size.width * 0.9932432,
        size.height * 0.8994120,
        size.width * 0.9932432,
        size.height * 0.8000000);
    path_0.lineTo(size.width * 0.9932432, size.height * 0.2000000);
    path_0.close();

    Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01351351;
    paint0Stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_0, paint0Stroke);

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Colors.transparent;
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RightShapeCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.006756757, size.height * 0.2000000);
    path_0.cubicTo(
        size.width * 0.006756757,
        size.height * 0.1005888,
        size.width * 0.03398270,
        size.height * 0.02000000,
        size.width * 0.06756757,
        size.height * 0.02000000);
    path_0.lineTo(size.width * 0.8459054, size.height * 0.02000000);
    path_0.cubicTo(
        size.width * 0.8643784,
        size.height * 0.02000000,
        size.width * 0.8818514,
        size.height * 0.04485620,
        size.width * 0.8933919,
        size.height * 0.08755480);
    path_0.lineTo(size.width * 0.9744730, size.height * 0.3875540);
    path_0.cubicTo(
        size.width * 0.9922365,
        size.height * 0.4532940,
        size.width * 0.9922365,
        size.height * 0.5467060,
        size.width * 0.9744730,
        size.height * 0.6124460);
    path_0.lineTo(size.width * 0.8933919, size.height * 0.9124460);
    path_0.cubicTo(
        size.width * 0.8818514,
        size.height * 0.9551440,
        size.width * 0.8643784,
        size.height * 0.9800000,
        size.width * 0.8459054,
        size.height * 0.9800000);
    path_0.lineTo(size.width * 0.06756757, size.height * 0.9800000);
    path_0.cubicTo(
        size.width * 0.03398270,
        size.height * 0.9800000,
        size.width * 0.006756757,
        size.height * 0.8994120,
        size.width * 0.006756757,
        size.height * 0.8000000);
    path_0.lineTo(size.width * 0.006756757, size.height * 0.2000000);
    path_0.close();

    Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01351351;
    paint0Stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_0, paint0Stroke);

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Colors.transparent;
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
