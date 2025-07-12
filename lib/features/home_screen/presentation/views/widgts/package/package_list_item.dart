import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../views_model/packages/packages_model.dart';
import '../../../../../../core/widgets/loading.dart'; // Assuming this contains CustomDotsTriangleLoader

class PackageListItem extends StatelessWidget {
  const PackageListItem({
    super.key,
    required this.package,
  });

  final Package package;

  String _shortenText(String fullText, int wordLimit) {
    List<String> words = fullText.split(' ');
    if (words.length > wordLimit) {
      return "${words.sublist(0, wordLimit).join(' ')} ...";
    }
    return fullText;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final Locale currentLocale = Localizations.localeOf(context);

    String getLocalizedText(String arabicText, String englishText) {
      return currentLocale.languageCode == 'ar' ? arabicText : englishText;
    }

    return GestureDetector(
      onTap: () {
        context.push(
          '/PackageDetails',
          extra: {'package': package},
        );
      },
      child: SizedBox(
        width: screenWidth * 0.4,
        height: screenHeight * 0.35,
        child: Column(
          children: [

            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12), // Adjusted for smoother corners
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
                      imageUrl: package.imageUrl,
                      fit: BoxFit.cover,
                      width: screenWidth * 0.4,
                      height: screenHeight * 0.20,
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
                      '${package.discountedPrice} دينار',
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
                  //       package. ?.toStringAsFixed(1) ?? '0.0',
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
                  // Package Name
                  Text(
                    _shortenText(
                      getLocalizedText(package.nameAr, package.nameEn),
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
                    getLocalizedText(
                      package.descriptionAr ?? '',
                      package.descriptionEn ?? '',
                    ).isNotEmpty
                        ? _shortenText(
                      getLocalizedText(
                        package.descriptionAr ?? '',
                        package.descriptionEn ?? '',
                      ),
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