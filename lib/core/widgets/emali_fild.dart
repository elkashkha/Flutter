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
  _EmailFieldState createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(
            widget.hint,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.primary,
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
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon, color: Colors.grey),
            hintText: widget.hint,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.gray, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.gray, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.gray, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}

