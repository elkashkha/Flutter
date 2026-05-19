import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../views_model/packages/packages_model.dart';

/// Clips a circular notch out of the top-left corner of the image,
/// with smooth concave flares connecting to the edges (squircle style).
class _TopLeftNotchClipper extends CustomClipper<Path> {
  final double s; // center offset (x and y)
  final double r; // radius of the notch arc
  final double f; // flare size
  final double cr; // corner radius of the card

  const _TopLeftNotchClipper({
    this.s = 22,
    this.r = 22,
    this.f = 14,
    this.cr = 16,
  });

  @override
  Path getClip(Size size) {
    final path = Path();

    // Start at top edge, right after the cutout flare
    path.moveTo(s + r + f, 0);

    // Top edge -> top-right rounded corner
    path.lineTo(size.width - cr, 0);
    path.quadraticBezierTo(size.width, 0, size.width, cr);

    // Right edge -> bottom-right rounded corner
    path.lineTo(size.width, size.height - cr);
    path.quadraticBezierTo(
        size.width, size.height, size.width - cr, size.height);

    // Bottom edge -> bottom-left rounded corner
    path.lineTo(cr, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - cr);

    // Left edge -> up to the start of the cutout flare
    path.lineTo(0, s + r + f);

    // Bottom flare (concave, connects left edge to notch)
    path.quadraticBezierTo(0, s + r, s, s + r);

    // The notch arc (curves inward towards the center s, s)
    path.arcToPoint(
      Offset(s + r, s),
      radius: Radius.circular(r),
      clockwise: false,
    );

    // Top flare (concave, connects notch to top edge)
    path.quadraticBezierTo(s + r, 0, s + r + f, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class PackageListItem extends StatelessWidget {
  const PackageListItem({super.key, required this.package});

  final Package package;

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final name = isArabic ? package.nameAr : package.nameEn;
    final description = isArabic
        ? (package.descriptionAr ?? '')
        : (package.descriptionEn ?? '');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        context.push('/PackageDetails', extra: {'package': package});
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF222121) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image with top-left notch ──
            Stack(
              children: [
                ClipPath(
                  clipper: const _TopLeftNotchClipper(),
                  child: Container(
                    height: 124,
                    width: 150,
                    color: isDark ? const Color(0xFF2C2B2B) : const Color(0xFFF5F5F5),
                    child: Image.asset(
                      'assets/images/pacakage.jpeg',
                      width: 150,
                      height: 124,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Back arrow button sitting exactly in the center of the notch
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2C2B2C) : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? Colors.white70 : Colors.black,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      size: 16,
                      color: isDark ? Colors.white : Colors.black,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ),
              ],
            ),

            // ── Text section ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + Price row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      textDirection:
                          isArabic ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: GoogleFonts.tajawal(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${package.discountedPrice} دينار',
                          style: GoogleFonts.tajawal(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Description
                    if (description.isNotEmpty)
                      Flexible(
                        child: Text(
                          description,
                          style: GoogleFonts.tajawal(
                            fontSize: 12,
                            color: isDark ? Colors.white70 : Colors.black87,
                            height: 1.5,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textDirection:
                              isArabic ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
