import 'package:flutter/material.dart';
import 'dart:math' as math;



class CircularProgress extends StatelessWidget {
  final double percentage;
  final double size;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;
  final bool showPercentage;
  final TextStyle? textStyle;

  const CircularProgress({
    Key? key,
    required this.percentage,
    this.size = 100,
    this.strokeWidth = 8,
    this.progressColor = Colors.black,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.showPercentage = true,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: CircularProgressPainter(
          percentage: percentage,
          strokeWidth: strokeWidth,
          progressColor: progressColor,
          backgroundColor: backgroundColor,
        ),
        child: showPercentage
            ? Center(
          child: Text(
            '${percentage.toInt()}%',
            style: textStyle ??
                TextStyle(
                  fontSize: size * 0.15,
                  fontWeight: FontWeight.bold,
                  color: progressColor,
                ),
          ),
        )
            : null,
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double percentage;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;

  CircularProgressPainter({
    required this.percentage,
    required this.strokeWidth,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // رسم الدائرة الخلفية
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // رسم دائرة التقدم
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * (percentage / 100);
    const startAngle = -math.pi / 2; // البدء من الأعلى

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class AnimatedCircularProgress extends StatefulWidget {
  final double percentage;
  final double size;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;
  final Duration duration;

  const AnimatedCircularProgress({
    Key? key,
    required this.percentage,
    this.size = 120,
    this.strokeWidth = 8,
    this.progressColor = Colors.blue,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.duration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  _AnimatedCircularProgressState createState() => _AnimatedCircularProgressState();
}

class _AnimatedCircularProgressState extends State<AnimatedCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.percentage,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_controller.isCompleted) {
          _controller.reverse();
        } else {
          _controller.forward();
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: CircularProgressPainter(
                percentage: _animation.value,
                strokeWidth: widget.strokeWidth,
                progressColor: widget.progressColor,
                backgroundColor: widget.backgroundColor,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${_animation.value.toInt()}%',
                      style: TextStyle(
                        fontSize: widget.size * 0.15,
                        fontWeight: FontWeight.bold,
                        color: widget.progressColor,
                      ),
                    ),
                    Text(
                      'اضغط للتحكم',
                      style: TextStyle(
                        fontSize: widget.size * 0.08,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// مثال على مخطط دائري متقدم مع عدة أجزاء
class MultiSegmentCircularProgress extends StatelessWidget {
  final List<ProgressSegment> segments;
  final double size;
  final double strokeWidth;

  const MultiSegmentCircularProgress({
    Key? key,
    required this.segments,
    this.size = 120,
    this.strokeWidth = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: MultiSegmentPainter(
          segments: segments,
          strokeWidth: strokeWidth,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'إجمالي',
                style: TextStyle(
                  fontSize: size * 0.08,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '${segments.fold<double>(0, (sum, segment) => sum + segment.percentage).toInt()}%',
                style: TextStyle(
                  fontSize: size * 0.15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressSegment {
  final double percentage;
  final Color color;
  final String label;

  ProgressSegment({
    required this.percentage,
    required this.color,
    required this.label,
  });
}

class MultiSegmentPainter extends CustomPainter {
  final List<ProgressSegment> segments;
  final double strokeWidth;

  MultiSegmentPainter({
    required this.segments,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // رسم الدائرة الخلفية
    final backgroundPaint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    // رسم الأجزاء
    double currentAngle = -math.pi / 2;

    for (var segment in segments) {
      final segmentPaint = Paint()
        ..color = segment.color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * math.pi * (segment.percentage / 100);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        sweepAngle,
        false,
        segmentPaint,
      );

      currentAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// مثال لاستخدام المخطط متعدد الأجزاء
class ExampleUsage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiSegmentCircularProgress(
      size: 150,
      strokeWidth: 10,
      segments: [
        ProgressSegment(
          percentage: 30,
          color: Colors.blue,
          label: 'مكتمل',
        ),
        ProgressSegment(
          percentage: 20,
          color: Colors.orange,
          label: 'قيد التنفيذ',
        ),
        ProgressSegment(
          percentage: 15,
          color: Colors.red,
          label: 'متأخر',
        ),
      ],
    );
  }
}