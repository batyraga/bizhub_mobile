import 'package:flutter/material.dart';

class ThirdTab extends StatelessWidget {
  const ThirdTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: Size(
                          MediaQuery.of(context).size.width - 60,
                          ((MediaQuery.of(context).size.width + 35) *
                                  0.9111675126903553)
                              .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                      painter: BGShapeCustomPainter(),
                    ),
                    Image(
                        fit: BoxFit.contain,
                        width: MediaQuery.of(context).size.width - 80,
                        image: const AssetImage(
                            "assets/images/become-seller-3.png")),
                  ],
                ),
              ),
              Positioned(
                  bottom: 20,
                  right: 20,
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 6,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: Colors.black),
                      ),
                    ],
                  ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: RichText(
            text: const TextSpan(
                text: "and ",
                style: TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
                children: [
                  TextSpan(text: "grow", style: TextStyle(color: Colors.blue)),
                  TextSpan(text: " your business with us!"),
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
    path_0.moveTo(size.width * 0.5719545, size.height * 0.1016419);
    path_0.cubicTo(
        size.width * 0.6722143,
        size.height * 0.09753750,
        size.width * 0.7673506,
        size.height * -0.03846389,
        size.width * 0.8496461,
        size.height * 0.01069711);
    path_0.cubicTo(
        size.width * 0.9404091,
        size.height * 0.06491500,
        size.width * 0.8683994,
        size.height * 0.1960436,
        size.width * 0.8864156,
        size.height * 0.2894889);
    path_0.cubicTo(
        size.width * 0.8960097,
        size.height * 0.3392472,
        size.width * 0.9130747,
        size.height * 0.3859028,
        size.width * 0.9312435,
        size.height * 0.4338778);
    path_0.cubicTo(
        size.width * 0.9512175,
        size.height * 0.4866278,
        size.width * 1.006117,
        size.height * 0.5323444,
        size.width * 0.9992630,
        size.height * 0.5874806);
    path_0.cubicTo(
        size.width * 0.9924448,
        size.height * 0.6423528,
        size.width * 0.9149643,
        size.height * 0.6720250,
        size.width * 0.8951201,
        size.height * 0.7245278);
    path_0.cubicTo(
        size.width * 0.8622890,
        size.height * 0.8113889,
        size.width * 0.9395390,
        size.height * 0.9470889,
        size.width * 0.8464740,
        size.height * 0.9917389);
    path_0.cubicTo(
        size.width * 0.7569026,
        size.height * 1.034714,
        size.width * 0.6726429,
        size.height * 0.8968583,
        size.width * 0.5719545,
        size.height * 0.8795778);
    path_0.cubicTo(
        size.width * 0.4964253,
        size.height * 0.8666111,
        size.width * 0.4225065,
        size.height * 0.9119833,
        size.width * 0.3458117,
        size.height * 0.9058028);
    path_0.cubicTo(
        size.width * 0.2526981,
        size.height * 0.8983000,
        size.width * 0.1456886,
        size.height * 0.8965917,
        size.width * 0.07967370,
        size.height * 0.8399139);
    path_0.cubicTo(
        size.width * 0.01450763,
        size.height * 0.7839639,
        size.width * -0.01385114,
        size.height * 0.6915083,
        size.width * 0.006479286,
        size.height * 0.6144611);
    path_0.cubicTo(
        size.width * 0.02749575,
        size.height * 0.5348139,
        size.width * 0.1646279,
        size.height * 0.5082250,
        size.width * 0.1880812,
        size.height * 0.4290778);
    path_0.cubicTo(
        size.width * 0.2106718,
        size.height * 0.3528417,
        size.width * 0.1059708,
        size.height * 0.2778639,
        size.width * 0.1287968,
        size.height * 0.2016792);
    path_0.cubicTo(
        size.width * 0.1510653,
        size.height * 0.1273539,
        size.width * 0.2200588,
        size.height * 0.05249694,
        size.width * 0.3067737,
        size.height * 0.03292222);
    path_0.cubicTo(
        size.width * 0.3972110,
        size.height * 0.01250714,
        size.width * 0.4785292,
        size.height * 0.1054669,
        size.width * 0.5719545,
        size.height * 0.1016419);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xff4285F4).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
