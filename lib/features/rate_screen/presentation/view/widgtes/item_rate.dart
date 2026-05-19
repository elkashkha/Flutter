import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/app_theme.dart';

class RateService extends StatelessWidget {
  final String name;
  final int rating;
  final String comment;
  final String? userImage;
  final String reviewDate;

  const RateService({
    super.key,
    required this.name,
    required this.rating,
    required this.comment,
    this.userImage,
    required this.reviewDate,
  });

  /// Formats the date string (e.g. "2026-05-20T...") to "20 مايو 2026"
  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      const arMonths = [
        'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
        'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
      ];
      return '${dt.day} ${arMonths[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  bool get _hasValidImage =>
      userImage != null &&
      userImage!.isNotEmpty &&
      userImage != 'null' &&
      !userImage!.contains('default-user.png');

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── Top row: Stars (left)  |  Name + Avatar (right) ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stars (left‑aligned)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < rating
                          ? CupertinoIcons.star_fill
                          : CupertinoIcons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Name + date (next to avatar)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.tajawal(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(reviewDate),
                      style: GoogleFonts.tajawal(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: isDark ? Colors.white60 : const Color(0xFFD1D1D1),
                      ),
                    ),
                  ],
                ),
              ),

              // Avatar
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFF0F0F0),
                backgroundImage:
                    _hasValidImage ? NetworkImage(userImage!) : null,
                child: _hasValidImage
                    ? null
                    : const Icon(Icons.person, color: Colors.grey, size: 24),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ── Comment ──
          SizedBox(
            width: double.infinity,
            child: Text(
              comment.isNotEmpty ? comment : 'لا توجد تعليقات',
              style: GoogleFonts.tajawal(
                fontSize: 14,
                color: isDark ? Colors.white : AppTheme.primary,
                height: 1.6,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}