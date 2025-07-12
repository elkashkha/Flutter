import 'package:flutter/cupertino.dart';

class _ZoomInOutAnimation extends StatefulWidget {
  final Widget child;
  const _ZoomInOutAnimation({required this.child});

  @override
  State<_ZoomInOutAnimation> createState() => _ZoomInOutAnimationState();
}

class _ZoomInOutAnimationState extends State<_ZoomInOutAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
