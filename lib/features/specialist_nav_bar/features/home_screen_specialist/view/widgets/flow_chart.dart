import 'package:flutter/material.dart';
import 'dart:math' as math;

class WavyChart extends StatelessWidget {
  final List<ChartData> data;

  const WavyChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 220,
      child: CustomPaint(
        painter: WavyChartPainter(data),
        child: Container(),
      ),
    );
  }
}

class ChartData {
  final String month;
  final double value;

  ChartData(this.month, this.value);
}

class WavyChartPainter extends CustomPainter {
  final List<ChartData> data;

  WavyChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final textPaint = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
    );

    double maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    double minValue = data.map((e) => e.value).reduce((a, b) => a < b ? a : b);

    // Find index of max value to highlight
    int maxIndex = 0;
    double maxVal = data[0].value;
    for (int i = 1; i < data.length; i++) {
      if (data[i].value > maxVal) {
        maxVal = data[i].value;
        maxIndex = i;
      }
    }

    List<Offset> points = [];
    double stepX = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      double x = i * stepX;

      // ✅ تفادي القسمة على صفر
      double normalizedValue;
      if (maxValue == minValue) {
        normalizedValue = 0.5;
      } else {
        normalizedValue = (data[i].value - minValue) / (maxValue - minValue);
      }

      double y = size.height - 60 - (normalizedValue * (size.height - 100));
      points.add(Offset(x, y));
    }

    // رسم الخط المموج
    Path path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      double controlX1 = points[i].dx + stepX * 0.4;
      double controlY1 = points[i].dy;
      double controlX2 = points[i + 1].dx - stepX * 0.4;
      double controlY2 = points[i + 1].dy;

      path.cubicTo(
        controlX1,
        controlY1,
        controlX2,
        controlY2,
        points[i + 1].dx,
        points[i + 1].dy,
      );
    }

    canvas.drawPath(path, linePaint);

    // رسم النقاط والقيم
    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 4, fillPaint);

      if (i == maxIndex && maxValue > 0) {
        double circleY = points[i].dy - 15;
        if (circleY < 0) circleY = points[i].dy + 15; // Avoid going off top
        canvas.drawCircle(
          Offset(points[i].dx, circleY),
          12,
          fillPaint,
        );

        textPaint.text = TextSpan(
          text: '${data[i].value.toInt()}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        );
        textPaint.layout();
        textPaint.paint(
          canvas,
          Offset(
            points[i].dx - textPaint.width / 2,
            circleY - textPaint.height / 2,
          ),
        );
      }

      textPaint.text = TextSpan(
        text: data[i].month,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 11,
        ),
      );
      textPaint.layout();
      textPaint.paint(
        canvas,
        Offset(points[i].dx - textPaint.width / 2, size.height - 30),
      );
    }

    // رسم قيم المحور Y بشكل ديناميكي
    if (maxValue == minValue) {
      // If all values same, show single label
      double normalizedValue = 0.5;
      double y = size.height - 60 - (normalizedValue * (size.height - 100));
      textPaint.text = TextSpan(
        text: '${minValue.toInt()}',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 10,
        ),
      );
      textPaint.layout();
      textPaint.paint(canvas, Offset(-25, y - textPaint.height / 2));
    } else {
      double range = maxValue - minValue;
      double tickStep = math.max(1, (range / 5).ceilToDouble());
      for (double tick = minValue; tick <= maxValue + 0.001; tick += tickStep) {
        double normalizedValue = (tick - minValue) / (maxValue - minValue);
        double y = size.height - 60 - (normalizedValue * (size.height - 100));

        textPaint.text = TextSpan(
          text: '${tick.toInt()}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 10,
          ),
        );
        textPaint.layout();
        textPaint.paint(canvas, Offset(-25, y - textPaint.height / 2));
      }
    }

    // رسم العنوان
    textPaint.text = const TextSpan(
      text: '',
      style: TextStyle(
        color: Colors.black87,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
    textPaint.layout();
    textPaint.paint(canvas, Offset(size.width - textPaint.width, -25));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
