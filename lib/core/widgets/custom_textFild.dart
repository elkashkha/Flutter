import 'package:flutter/material.dart';
import '../../../../../../core/app_theme.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.taskController,
    required this.hint,
    this.maxLines = 1,
    this.ispassword = false,
    this.validate,
    this.icon = Icons.email,
    this.suffixIcon,
  });

  final TextEditingController taskController;
  final String hint;
  final int maxLines;
  final bool ispassword;
  final String? Function(String?)? validate;
  final IconData icon;
  final Widget? suffixIcon;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(
            widget.hint,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? const Color(0xFFC0A476) : AppTheme.primary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: widget.taskController,
          maxLines: widget.maxLines,
          obscureText: widget.ispassword && !_isPasswordVisible,
          validator: widget.validate,
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white : const Color(0xff464545),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon, color: isDark ? Colors.white60 : Colors.grey),
            suffixIcon: widget.ispassword
                ? IconButton(
              icon: Icon(
                _isPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: isDark ? Colors.white60 : const Color(0xff464545),
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            )
                : widget.suffixIcon,
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: isDark ? Colors.white54 : const Color(0xff464545),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            alignLabelWithHint: true,
            filled: true,
            fillColor: isDark ? const Color(0xFF2C2C2C) : const Color(0xffF2F2F2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(color: isDark ? const Color(0xFF2C2C2C) : const Color(0xffF2F2F2), width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(color: isDark ? const Color(0xFF2C2C2C) : const Color(0xffF2F2F2), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(color: isDark ? const Color(0xFF2C2C2C) : const Color(0xffF2F2F2), width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}

