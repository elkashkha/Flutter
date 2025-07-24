import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkashkha/features/product_categories/presentation/view/widgets/products/view_model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../core/widgets/loading.dart';

class ProductItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final Product product;

  final double price;
  final double originalPrice;
  final double rating;

  const ProductItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final screenWidth = MediaQuery.of(context).size.width > 600
        ? MediaQuery.of(context).size.width * .75
        : MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final languageCode = Localizations.localeOf(context).languageCode;
    final isArabic = languageCode == 'ar';

    return GestureDetector(
      onTap: () {
        context.push(
          '/ProductDetails',
          extra: {'product': product},
        );
      },
      child: Container(
        width: screenWidth * 0.45,
        height: MediaQuery.of(context).size.width > 600
            ? screenHeight * 0.65
            : screenHeight * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000000),
              Color(0x78000000),
              Color(0xFFFFFFFF),
              Color(0xFFB0AEAE),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: screenHeight * 0.18,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CustomDotsTriangleLoader(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, size: 40, color: Colors.red),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenHeight * 0.005,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.47),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          rating.toString(),
                          style: GoogleFonts.tajawal(
                            fontSize: screenWidth * 0.03,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.star,
                            color: Colors.amber, size: screenWidth * 0.04),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.007),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              child: Text(
                locale == 'ar' ? product.nameAr : (product.nameEn),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.tajawal(
                  fontSize: screenWidth * 0.030,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.002),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              child: Text(
                locale == 'ar'
                    ? product.descriptionAr
                    : (product.descriptionEn ?? product.descriptionAr),
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.tajawal(
                  fontSize: screenWidth * 0.030,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              child: Row(
                children: [
                  Text(
                    '$originalPrice ${localization.currency}',
                    style: GoogleFonts.tajawal(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$price ${localization.currency}',
                    style: GoogleFonts.tajawal(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              height: screenHeight * 0.05,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF000000),
                    Color(0xFF7B7574),
                    Color(0xFFB0AEAE),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Text(
                  isArabic ? 'أضف إلى العربة' : 'Add to Cart',
                  style: GoogleFonts.tajawal(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
