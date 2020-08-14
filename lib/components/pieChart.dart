import 'package:flutter/cupertino.dart';
import 'dart:math';

class PieChart extends CustomPainter {
  double width;
  double totalMarks;
  double score;
  List<double> marks;
  double percentage;
  PieChart(
      {this.percentage, this.totalMarks, this.score, this.width, this.marks});
  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.width / 2);
    double radius = min(size.width / 2, size.height / 2);
    print(size.width);
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width / 2;
    double startRadian = -pi / 2;
    for (var index = 0; index < marks.length; index++) {
      final sweepRadian = marks[index] * 2 * pi;

      paint.color = kColour.elementAt(index);
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
          startRadian, sweepRadian, false, paint);
      startRadian += sweepRadian;
    }

//    paint.color = kColour.elementAt(1);
//    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), sweepRadian,
//        endSweep, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

final kColour = [
  Color.fromRGBO(82, 98, 255, 1),
  Color.fromRGBO(255, 255, 255, 1)
];
