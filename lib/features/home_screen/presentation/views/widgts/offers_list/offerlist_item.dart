import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../views_model/offers/offers_model.dart';
import '../../../../../../core/widgets/loading.dart'; // Contains CustomDotsTriangleLoader

class OfferlistItem extends StatelessWidget {
  const OfferlistItem({super.key, required this.offer});

  final Offer offer;

  String _shortenText(String fullText, int wordLimit) {
    List<String> words = fullText.split(' ');
    if (words.length > wordLimit) {
      return "${words.sublist(0, wordLimit).join(' ')} ...";
    }
    return fullText;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width>600?MediaQuery.of(context).size.width*.8:MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return GestureDetector(
      onTap: () {
        context.push(
          '/OffersDetails',
          extra: {'offer': offer},
        );
      },
      child: SizedBox(
        width: screenWidth * 0.4,
        height: screenHeight * 0.35,
        child: Column(
          children: [
            // Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: offer.imageUrl.isNotEmpty
                          ? offer.imageUrl
                          : 'https://cdn.vectorstock.com/i/1000v/97/22/no-picture-vector-739722.avif',
                      fit: BoxFit.cover,
                      width: screenWidth * 0.4,
                      height: screenHeight * 0.22,
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                      const Center(child: CustomDotsTriangleLoader()),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.error, color: Colors.red, size: 40),
                      ),
                    ),
                  ),
                ),
                // SVG Overlay
                Positioned(
                  left: -6,
                  bottom: -5,
                  child: SvgPicture.asset(
                    'assets/images/Subtract2 (3)-cropped.svg',
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.08,
                    fit: BoxFit.fill,
                  ),
                ),
                // Price Tag
                Positioned(
                  bottom: screenHeight * 0.01,
                  left: screenWidth * 0.02,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenHeight * 0.005,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${offer.discountedPrice} دينار',
                      style: GoogleFonts.tajawal(
                        textStyle: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Text Section
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating
                  // Row(
                  //   children: [
                  //     Text(
                  //       offer.averageRating?.toStringAsFixed(1) ?? '0.0',
                  //       style: GoogleFonts.tajawal(
                  //         textStyle: TextStyle(
                  //           fontSize: screenWidth * 0.035,
                  //           color: Colors.black,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(width: screenWidth * 0.01),
                  //     Icon(Icons.star,
                  //         color: Colors.yellow, size: screenWidth * 0.04),
                  //   ],
                  // ),
                  SizedBox(height: screenHeight * 0.01),
                  // Offer Title
                  Text(
                    _shortenText(
                      isArabic ? offer.titleAr : offer.titleEn,
                      3,
                    ),
                    style: GoogleFonts.tajawal(
                      textStyle: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  // Description
                  Text(
                    (isArabic ? offer.descriptionAr : offer.descriptionEn)
                        .isNotEmpty
                        ? _shortenText(
                      isArabic ? offer.descriptionAr : offer.descriptionEn,
                      10,
                    )
                        : 'No description available',
                    style: GoogleFonts.tajawal(
                      textStyle: TextStyle(
                        fontSize: screenWidth * 0.030,
                        color: Colors.black,
                      ),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}