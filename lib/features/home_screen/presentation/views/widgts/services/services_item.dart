import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../core/widgets/loading.dart';
import '../../../views_model/services/services_model.dart';

class ListServiceItem extends StatelessWidget {
  const ListServiceItem({
    super.key,
    required this.imageUrl,
    required this.text,
    required this.serviceId,
    required this.details,
    this.textColor = Colors.white,
    required this.price,
    required this.rate,
    required this.service,
  });

  final String price;
  final double rate;
  final String imageUrl;
  final String text;
  final int serviceId;
  final Details details;
  final Color textColor;
  final Service service;

  String _shortenText(String fullText, int wordLimit) {
    List<String> words = fullText.split(' ');
    if (words.length > wordLimit) {
      return "${words.sublist(0, wordLimit).join(' ')} ...";
    }
    return fullText;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width>600?MediaQuery.of(context).size.width*.75:MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final locale = Localizations.localeOf(context).languageCode;
    final isArabic = locale == 'ar';

    return GestureDetector(
      onTap: () {
        context.push(
          '/ServiceDetails',
          extra: {
            'service': {
              'imageUrl': imageUrl,
              'name_ar': text,
              'name_en': text,
              'price': price,
              'rate': rate,
              'duration': service.duration,
              'description_ar': service.descriptionAr,
              'description_en': service.descriptionEn,
              'details': {
                'tools': details.tools,
                'staff': details.staff,
              },
              'reviews': service.reviews,
            },
          },
        );
      },
      child: SizedBox(
        width: screenWidth * 0.4,
        height: screenHeight * 0.36,
        child: Column(
          children: [
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
                      imageUrl: imageUrl,
                      fit: BoxFit.fill,
                      width: screenWidth * 0.4,
                      height: screenHeight * 0.22,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              const Center(child: CustomDotsTriangleLoader()),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.error, color: Colors.red, size: 40),
                      ),
                    ),
                  ),
                ),
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
                      '$price دينار',
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
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating
                  Row(
                    children: [
                      Text(
                        rate.toStringAsFixed(1),
                        style: GoogleFonts.tajawal(
                          textStyle: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Icon(Icons.star,
                          color: Colors.yellow, size: screenWidth * 0.04),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  // Service Name
                  Text(
                    _shortenText(text, 3),
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
                    service.descriptionAr.isNotEmpty
                        ? service.descriptionAr
                        : service.descriptionEn,
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

// class CustomCardClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     double width = size.width;
//     double height = size.height;
//
//     path.moveTo(0, 0);
//     path.lineTo(0, height * 0.63);
//     path.quadraticBezierTo(
//         width * 0.05, height * 0.72, width * 0.23, height * 0.72);
//     path.lineTo(width * 0.29, height * 0.72);
//     path.quadraticBezierTo(
//         width * 0.31, height * 0.81, width * 0.29, height * 0.91);
//     path.lineTo(width * 0.29, height * 0.91);
//     path.quadraticBezierTo(
//         width * 0.32, height * 1.0, width * 0.34, height * 1.0);
//     path.lineTo(width, height);
//     path.lineTo(width, 0);
//     path.close();
//
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => true;
// }
