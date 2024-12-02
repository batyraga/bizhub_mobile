import 'package:flutter/material.dart';

class FirstTab extends StatelessWidget {
  const FirstTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: -30,
                right: -40,
                child: CustomPaint(
                  size: Size(
                      MediaQuery.of(context).size.width + 180,
                      ((MediaQuery.of(context).size.width + 75) *
                              0.9111675126903553)
                          .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                  painter: BGShapeCustomPainter(),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width / 10,
                child: Image(
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width - 80,
                    image:
                        const AssetImage("assets/images/become-seller-1.png")),
              ),
              Positioned(
                  bottom: 20,
                  right: 20,
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: Colors.black),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: Colors.grey),
                      )
                    ],
                  ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: RichText(
            text: TextSpan(
                text: "Become a ",
                style: const TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
                children: [
                  TextSpan(
                      text: "seller",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary)),
                  const TextSpan(text: " in our platform,"),
                ]),
          ),
        )
      ],
    );
  }
}

class BGShapeCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.5150279, size.height * 0.1074323);
    path_0.cubicTo(
        size.width * 0.5905406,
        size.height * 0.08958440,
        size.width * 0.6493579,
        size.height * -0.02095727,
        size.width * 0.7233071,
        size.height * 0.003521031);
    path_0.cubicTo(
        size.width * 0.7918223,
        size.height * 0.02620006,
        size.width * 0.7916371,
        size.height * 0.1381421,
        size.width * 0.8221574,
        size.height * 0.2090944);
    path_0.cubicTo(
        size.width * 0.8470127,
        size.height * 0.2668838,
        size.width * 0.8618655,
        size.height * 0.3268774,
        size.width * 0.8871523,
        size.height * 0.3844401);
    path_0.cubicTo(
        size.width * 0.9194721,
        size.height * 0.4580139,
        size.width * 0.9827360,
        size.height * 0.5160334,
        size.width * 0.9925457,
        size.height * 0.5969777);
    path_0.cubicTo(
        size.width * 1.003122,
        size.height * 0.6842702,
        size.width * 1.012830,
        size.height * 0.8071643,
        size.width * 0.9438528,
        size.height * 0.8523259);
    path_0.cubicTo(
        size.width * 0.8616523,
        size.height * 0.9061421,
        size.width * 0.7579594,
        size.height * 0.8053064,
        size.width * 0.6624721,
        size.height * 0.8130836);
    path_0.cubicTo(
        size.width * 0.6078579,
        size.height * 0.8175320,
        size.width * 0.5649569,
        size.height * 0.8625933,
        size.width * 0.5150279,
        size.height * 0.8872507);
    path_0.cubicTo(
        size.width * 0.4378223,
        size.height * 0.9253816,
        size.width * 0.3699822,
        size.height * 1.009682,
        size.width * 0.2858528,
        size.height * 0.9990864);
    path_0.cubicTo(
        size.width * 0.2073175,
        size.height * 0.9891950,
        size.width * 0.1315901,
        size.height * 0.9173454,
        size.width * 0.1052931,
        size.height * 0.8356407);
    path_0.cubicTo(
        size.width * 0.07760964,
        size.height * 0.7496240,
        size.width * 0.1664066,
        size.height * 0.6582897,
        size.width * 0.1475741,
        size.height * 0.5694457);
    path_0.cubicTo(
        size.width * 0.1286297,
        size.height * 0.4800752,
        size.width * -0.01964863,
        size.height * 0.4378189,
        size.width * 0.002189277,
        size.height * 0.3492423);
    path_0.cubicTo(
        size.width * 0.02454142,
        size.height * 0.2585808,
        size.width * 0.1605332,
        size.height * 0.2824568,
        size.width * 0.2313614,
        size.height * 0.2296008);
    path_0.cubicTo(
        size.width * 0.2786548,
        size.height * 0.1943081,
        size.width * 0.2926878,
        size.height * 0.1156474,
        size.width * 0.3459391,
        size.height * 0.09271309);
    path_0.cubicTo(
        size.width * 0.3992310,
        size.height * 0.06976184,
        size.width * 0.4590558,
        size.height * 0.1206613,
        size.width * 0.5150279,
        size.height * 0.1074323);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xff6E5AD1).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
