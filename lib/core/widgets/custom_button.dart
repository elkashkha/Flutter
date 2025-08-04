import 'package:flutter/material.dart';
import '../../../../../../core/app_theme.dart';

class MyCustomButton extends StatelessWidget {
  const MyCustomButton({
    super.key,
    this.text,
    this.child,
    required this.voidCallback,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.borderColor,
    this.width,
    this.height,
    this.fontSize,
  });

  final String? text;
  final Widget? child;
  final VoidCallback? voidCallback;
  final bool isLoading;
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
        onPressed: () {
          if (!isLoading) {
            voidCallback?.call();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
          ),
        ),
        child: isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : child ??
            Text(
              text ?? '',
              style: TextStyle(
                color: textColor, // 👈 دلوقتي هيتغير فعليًا
                fontSize: textFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
      ),
    );
  }
}
