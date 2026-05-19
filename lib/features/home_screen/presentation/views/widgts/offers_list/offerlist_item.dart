import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../views_model/offers/offers_model.dart';
import '../../../../../../core/widgets/loading.dart';

/// Clips a circular notch out of the top-left corner of the image,
/// with smooth concave flares connecting to the edges (squircle style).
class _TopLeftNotchClipper extends CustomClipper<Path> {
  final double s; // center offset (x and y)
  final double r; // radius of the notch arc
  final double f; // flare size
  final double cr; // corner radius of the card

  const _TopLeftNotchClipper({
    this.s = 30,
    this.r = 30,
    this.f = 24,
    this.cr = 20,
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
    path.quadraticBezierTo(size.width, size.height, size.width - cr, size.height);

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

class OfferlistItem extends StatelessWidget {
  const OfferlistItem({super.key, required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final name = isArabic ? offer.titleAr : offer.titleEn;
    final description = isArabic
        ? (offer.descriptionAr)
        : (offer.descriptionEn);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        context.push('/OffersDetails', extra: {'offer': offer});
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
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
                  clipper: const _TopLeftNotchClipper(
                    s: 30,
                    r: 30,
                    f: 24,
                    cr: 20,
                  ),
                  child: Container(
                    height: 110,
                    width: double.infinity,
                    color: isDark ? const Color(0xFF2C2B2B) : const Color(0xFFF5F5F5),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/offer2v.svg',
                        width: 70,
                        height: 70,
                        fit: BoxFit.contain,
                        colorFilter: isDark
                            ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                            : null,
                      ),
                    ),
                  ),
                ),
                // Back arrow button sitting exactly in the center of the notch
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: isDark ? Colors.white : Colors.black, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios, // matching user's edit for packages
                      size: 16,
                      color: isDark ? Colors.white : Colors.black,
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
                          '${offer.discountedPrice} دينار',
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textDirection: isArabic
                              ? TextDirection.rtl
                              : TextDirection.ltr,
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