import 'dart:math';
import 'package:flutter/material.dart';

class AirQualityIndikator extends CustomPainter {
  final int aqi;
  //vuče aqi tj indeks zagađenosti iz api
  AirQualityIndikator(this.aqi);

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 40;
    double borderThickness = 10.0;

    final double radius = size.width / 2;

    final Paint borderPaint = Paint()
      ..color = Colors.white70
      ..style = PaintingStyle.stroke
      //širina stroke-a, da ne kopiram iz knjige otp
      ..strokeWidth = strokeWidth + borderThickness
      ..strokeCap = StrokeCap.square;

    // Nacrtaj beli poluluk, formula koju sam opet negde našao pa mikerio
    //za ovako divaljenje gleaj widget insepctor, ako ste sa matom na vi btk
    canvas.drawArc(
        //TODO: Pređi kursorom preko canvas
        Rect.fromCircle(
            center: Offset(radius, radius),
            radius: radius - 5 - borderThickness / 2),
        pi,
        pi,
        false,
        borderPaint);

    final Paint dialPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.green,
          Colors.yellow,
          Colors.orange,
          Colors.red,
          Colors.purple,
          Colors.brown
        ],
        stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
      ).createShader(
          Rect.fromCircle(center: Offset(radius, radius), radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Nacrtaj obojen poluluk
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(radius, radius), radius: radius - borderThickness),
        pi,
        pi,
        false,
        dialPaint);

    double normalizedAqi = aqi.clamp(0, 300) / 300;
    double angle = pi - normalizedAqi * pi;

    final Color needleColor = _getColorAtPosition(normalizedAqi);
    final Paint needlePaint = Paint()
      ..color = needleColor
      ..style = PaintingStyle.fill;
    //radijus poluluka
    double anchorRadius = 30.0;
    final Paint anchorPaint = Paint()..color = Colors.white; //boja
    //dužina ove iglice koja se ppomera
    double needleLength = radius - (strokeWidth + anchorRadius + 14);
    Offset start = Offset(radius, radius);
    Offset end = Offset(
        //bukvaslno iskopirao odnekudd  i usralo me da šljaka
        radius + needleLength * cos(angle),
        radius - needleLength * sin(angle));
    double arrowSize = 14.0;
    final Path borderPath = Path();

    //uradiću detaljnije objašnjenje ovoga kasnije
    borderPath.moveTo(start.dx, start.dy);
    borderPath.lineTo(end.dx + arrowSize * 1.2 * cos(angle + pi / 4),
        end.dy - arrowSize * 1.2 * sin(angle + pi / 4));
    borderPath.lineTo(end.dx + 2 * arrowSize * 1.2 * cos(angle),
        end.dy - 2 * arrowSize * 1.2 * sin(angle));
    borderPath.lineTo(end.dx + arrowSize * 1.2 * cos(angle - pi / 4),
        end.dy - arrowSize * 1.2 * sin(angle - pi / 4));
    borderPath.close();

    final Paint borderPaint2 = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0; // Debljina ivice tj border-a

    canvas.drawPath(borderPath, borderPaint2);
    canvas.drawPath(
        borderPath, needlePaint); // boja iglice kao boja mesta gde pokazuje

    // Sad nacrtaj putanju
    final Path path = Path();
    path.moveTo(start.dx, start.dy);
    path.lineTo(end.dx + arrowSize * cos(angle + pi / 4),
        end.dy - arrowSize * sin(angle + pi / 4));
    path.lineTo(end.dx + 2 * arrowSize * cos(angle),
        end.dy - 2 * arrowSize * sin(angle));
    path.lineTo(end.dx + arrowSize * cos(angle - pi / 4),
        end.dy - arrowSize * sin(angle - pi / 4));
    path.close();

    canvas.drawPath(path, needlePaint);
    canvas.drawCircle(start, anchorRadius, anchorPaint);
  }

  //boja na odgovarajućoj poziciji
  Color _getColorAtPosition(double position) {
    List<Color> colors = [
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.brown
    ];
    //kao graničnici, tip podataka lista, rastući redosled tip znate valjda
    List<double> stops = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0];
    for (int i = 0; i < stops.length - 1; i++) {
      if (position <= stops[i + 1]) {
        //objasniću posle
        double t = (position - stops[i]) / (stops[i + 1] - stops[i]);
        //lerp je interpolacija između dve boje, kojoj boji je blisko
        //lepo je  objašnjeno pređu kursorom preko lerp
        return Color.lerp(colors[i], colors[i + 1], t)!;
      }
    }
    return colors.last; //vrati na boju mesta gde je stala iglica
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    //da li treba ponovo da farba
    return false;
  }
}
