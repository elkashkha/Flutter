import 'package:flutter/material.dart';
import '../../../../../../core/app_theme.dart';

class MyCustomButton extends StatelessWidget {
  const MyCustomButton({
    super.key,
    required this.text,
    required this.voidCallback,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.borderColor,
    this.width,
    this.height,
    this.fontSize,
  });

  final String text;
  final VoidCallback? voidCallback;
  final Color? backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final buttonWidth = width ?? screenSize.width * 0.9;
    final buttonHeight = height ?? screenSize.height * 0.06;
    final textFontSize = fontSize ?? buttonWidth * 0.045;

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(

        onPressed: voidCallback,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: textFontSize,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
