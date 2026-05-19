import 'package:flutter/material.dart';
import '../../../../../core/app_theme.dart';

class BookingSelectionContainer extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> selectedNames;
  final VoidCallback onTap;

  const BookingSelectionContainer({
    super.key,
    required this.title,
    required this.icon,
    required this.selectedNames,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF222121) : Colors.white,
          borderRadius: BorderRadius.circular(60),
          border: Border.all(color: isDark ? Colors.grey.shade800 : AppTheme.gray, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: isDark ? Colors.white70 : Colors.grey.shade700, size: 24.0),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedNames.isEmpty ? title : selectedNames.join(', '),
                style: TextStyle(
                  color: selectedNames.isEmpty 
                      ? (isDark ? Colors.white38 : Colors.grey)
                      : (isDark ? Colors.white : Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
