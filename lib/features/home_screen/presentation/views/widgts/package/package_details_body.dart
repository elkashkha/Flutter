import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkashkha/core/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/widgets/loading.dart';
import '../../../views_model/packages/packages_model.dart';

class PackageDetailsBody extends StatelessWidget {
  const PackageDetailsBody({super.key});

  void _sendToWhatsapp(String name, String price,BuildContext context) async {
    const String whatsappNumber = "96555156388";
    // const String whatsappNumber = "+96555156388";
    final Uri whatsappUrl = Uri.parse(
        "https://wa.me/$whatsappNumber?text=مرحبًا! أرغب في حجز خدمة $name بسعر $price دينار.");

    // if (await canLaunchUrl(whatsappUrl)) {
    //   await launchUrl(whatsappUrl);
    // } else {}
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("يبدو أن WhatsApp غير مثبت على الجهاز."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data =
        GoRouterState.of(context).extra as Map<String, dynamic>;
    final Package package = data['package'];

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    Locale currentLocale = Localizations.localeOf(context);

    String getLocalizedText(String arabicText, String englishText) {
      if (currentLocale.languageCode == 'ar') {
        return arabicText;
      } else {
        return englishText;
      }
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: package.imageUrl,
              height: screenHeight * 0.35,
              width: double.infinity,
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(child: CustomDotsTriangleLoader()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                Text(
                  getLocalizedText(package.nameAr, package.nameEn),
                  style: GoogleFonts.tajawal(
                    textStyle: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Row(
                  children: [
                    Text(
                      "${package.discountedPrice} دينار",
                      style: GoogleFonts.tajawal(
                        textStyle: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Text(
                      "${package.originalPrice} دينار",
                      style: GoogleFonts.tajawal(
                        textStyle: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.black54,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  getLocalizedText(
                      package.descriptionAr, package.descriptionEn),
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.tajawal(
                    textStyle: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  getLocalizedText("الخدمات المتاحة ضمن العرض:",
                      "Services included in the offer:"),
                  style: GoogleFonts.tajawal(
                    textStyle: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: package.services.map((service) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check, color: Colors.green, size: 18),
                        SizedBox(width: screenWidth * 0.02),
                        Expanded(
                          child: Text(
                            service,
                            style: GoogleFonts.tajawal(
                              textStyle: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                SizedBox(height: screenWidth * 0.5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder<String?>(
                    future: SharedPreferences.getInstance().then((prefs) => prefs.getString('access_token')),
                    builder: (context, snapshot) {
                      final token = snapshot.data;
                      final isArabic = Localizations.localeOf(context).languageCode == 'ar';

                      if (token == null || token.isEmpty) {
                        return MyCustomButton(
                          text: isArabic ? 'يرجى تسجيل الدخول للحجز' : 'Please login to book',
                          voidCallback: () {
                            context.push('/LoginScreenView');
                          },
                        );
                      } else {
                        return MyCustomButton(
                          text: isArabic ? 'احجز الآن' : 'Book Now',
                          voidCallback: () {
                            context.push('/BookingService');
                          },
                        );
                      }
                    },
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
