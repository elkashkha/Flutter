import 'package:flutter/material.dart';
import '../app_theme.dart';

class EmailField extends StatefulWidget {
  const EmailField({
    super.key,
    required this.taskController,
    required this.hint,
    this.maxLines = 1,
    this.validate,
    this.suffixIcon,
    required this.icon,
  });

  final TextEditingController taskController;
  final String hint;
  final int maxLines;
  final String? Function(String?)? validate;
  final IconData icon;
  final Widget? suffixIcon;

  @override
  // ignore: library_private_types_in_public_api
  _EmailFieldState createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
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
          controller: widget.taskController,
          maxLines: widget.maxLines,
          validator: widget.validate,
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white : const Color(0xff464545),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon, color: isDark ? Colors.white60 : const Color(0xff464545)),
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: isDark ? Colors.white54 : const Color(0xff464545),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
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

