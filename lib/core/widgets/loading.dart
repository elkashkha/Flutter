import 'package:flutter/material.dart';

class CustomDotsTriangleLoader extends StatelessWidget {
  const CustomDotsTriangleLoader({
    super.key,
    this.color = Colors.black,
    this.size = 50,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/cut.gif',
      width: size,
      height: size,
      fit: BoxFit.fill,
      color: color,
      colorBlendMode: BlendMode.modulate,
    );
  }
}