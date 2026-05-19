import 'package:flutter/material.dart';

class WavyChart extends StatelessWidget {
  final List<ChartData> data;

  const WavyChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 220,
      child: CustomPaint(
        painter: BarChartPainter(data),
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

class BarChartPainter extends CustomPainter {
  final List<ChartData> data;

  BarChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    const double paddingLeft = 40.0;
    const double paddingRight = 10.0;
    const double paddingTop = 20.0;
    const double paddingBottom = 30.0;

    final double chartWidth = size.width - paddingLeft - paddingRight;
    final double chartHeight = size.height - paddingTop - paddingBottom;

    final double maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final double scaleMax = maxValue > 0 ? maxValue * 1.2 : 100.0; // headroom

    // Draw Y-axis labels and horizontal grid lines
    final linePaint = Paint()
      ..color = const Color(0xffE2E2E6).withOpacity(0.5)
      ..strokeWidth = 1.0;

    final textPaint = TextPainter(
      textAlign: TextAlign.right,
      textDirection: TextDirection.ltr,
    );

    final List<double> yTicks = [0, scaleMax * 0.25, scaleMax * 0.5, scaleMax * 0.75, scaleMax];
    for (var tick in yTicks) {
      double normalizedY = tick / scaleMax;
      double y = size.height - paddingBottom - (normalizedY * chartHeight);

      // Draw grid line
      canvas.drawLine(
        Offset(paddingLeft, y),
        Offset(size.width - paddingRight, y),
        linePaint,
      );

      // Draw Y label
      textPaint.text = TextSpan(
        text: tick == 0 ? '0k' : '${tick.toInt()}',
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      );
      textPaint.layout();
      textPaint.paint(
        canvas,
        Offset(paddingLeft - textPaint.width - 8, y - textPaint.height / 2),
      );
    }

    // Draw Bars and X-axis labels
    final double stepX = chartWidth / data.length;
    final double barWidth = stepX * 0.18;

    final blackBarPaint = Paint()
      ..color = const Color(0xff0B0B0F)
      ..style = PaintingStyle.fill;

    final greyBarPaint = Paint()
      ..color = const Color(0xffE2E2E6)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < data.length; i++) {
      double centerX = paddingLeft + (i * stepX) + (stepX / 2);
      double normalizedVal = data[i].value / scaleMax;
      double barHeight = normalizedVal * chartHeight;

      // Draw Grey Bar (slightly shifted right and shorter/different)
      double greyBarHeight = barHeight * 0.8;
      Rect greyRect = Rect.fromLTWH(
        centerX + 2,
        size.height - paddingBottom - greyBarHeight,
        barWidth,
        greyBarHeight,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(greyRect, const Radius.circular(4)),
        greyBarPaint,
      );

      // Draw Black Bar (main value bar)
      Rect blackRect = Rect.fromLTWH(
        centerX - barWidth - 2,
        size.height - paddingBottom - barHeight,
        barWidth,
        barHeight,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(blackRect, const Radius.circular(4)),
        blackBarPaint,
      );

      // Draw Month Label under the bars
      textPaint.text = TextSpan(
        text: data[i].month,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      );
      textPaint.layout();
      textPaint.paint(
        canvas,
        Offset(centerX - textPaint.width / 2, size.height - paddingBottom + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
