import 'package:elkashkha/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cherry_toast/cherry_toast.dart';

class GiftListItem extends StatelessWidget {
  final String imageUrl;
  final String titleAr;
  final String titleEn;
  final bool canClaim;
  final VoidCallback onClaimPressed;

  const GiftListItem({
    Key? key,
    required this.imageUrl,
    required this.titleAr,
    required this.titleEn,
    required this.canClaim,
    required this.onClaimPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    final title = isArabic ? titleAr : titleEn;
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Wide Gift Image
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            imageUrl,
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 180,
              color: isDark ? const Color(0xFF2C2B2B) : Colors.grey.shade100,
              alignment: Alignment.center,
              child: Icon(Icons.image_not_supported, size: 48, color: isDark ? Colors.white30 : Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Gift Text Details
        Text(
          isArabic ? 'هديتك!' : 'Your Gift!',
          style: GoogleFonts.tajawal(
            fontSize: 14,
            color: isDark ? Colors.white38 : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          isArabic 
              ? 'حصلت على $title مجاناً' 
              : 'You got a free $title',
          style: GoogleFonts.tajawal(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        
        // Claim Button
        GestureDetector(
          onTap: canClaim
              ? onClaimPressed
              : () {
                  CherryToast.warning(
                    title: Text(
                      isArabic
                          ? 'ليس لديك نقاط كافية لاستلام الهدية.'
                          : 'You do not have enough points to claim this gift.',
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ).show(context);
                },
          child: Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              color: canClaim 
                  ? (isDark ? const Color(0xff262626) : const Color(0xFF161616)) 
                  : (isDark ? const Color(0xFF222121) : Colors.grey.shade300),
              borderRadius: BorderRadius.circular(30),
              border: !canClaim && isDark ? Border.all(color: Colors.grey.shade800) : null,
            ),
            alignment: Alignment.center,
            child: Text(
              isArabic ? 'المطالبة بالهدية' : 'Claim Gift',
              style: GoogleFonts.tajawal(
                color: canClaim 
                    ? Colors.white 
                    : (isDark ? Colors.white30 : Colors.grey.shade600),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
