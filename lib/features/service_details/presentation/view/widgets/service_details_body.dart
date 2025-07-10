import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elkashkha/core/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/app_theme.dart';
import '../../../../../core/widgets/loading.dart';
import '../../../../rate_screen/presentation/view/widgtes/item_rate.dart';

class ServiceDetailsBody extends StatelessWidget {
  const ServiceDetailsBody({super.key});

  void _sendToWhatsapp(String nameAr, String nameEn, String price, BuildContext context) async {
    // const String whatsappNumber = "+96555156388";
    // Locale currentLocale = Localizations.localeOf(context);
    // String name = currentLocale.languageCode == 'ar' ? nameAr : nameEn;
    //
    // final Uri whatsappUrl = Uri.parse(
    //     "https://wa.me/$whatsappNumber?text=مرحبًا! أرغب في حجز خدمة $name بسعر $price دينار.");
    //
    // if (await canLaunchUrl(whatsappUrl)) {
    //   await launchUrl(whatsappUrl);
    // } else {}
  }

  String getLocalizedText(
      BuildContext context, String arabicText, String englishText) {
    Locale currentLocale = Localizations.localeOf(context);
    if (currentLocale.languageCode == 'ar') {
      return arabicText;
    } else {
      return englishText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final double screenHeight = mediaQuery.size.height;

    final Map<String, dynamic> data =
        GoRouterState.of(context).extra as Map<String, dynamic>;
    final Map<String, dynamic> service = data['service'] ?? {};

    final String imageUrl =
        service['imageUrl'] ?? 'https://via.placeholder.com/150';
    final String nameAr = service['name_ar'] ?? 'اسم غير متوفر';
    final String nameEn = service['name_en'] ?? 'Name not available';
    final String price = service['price'] ?? 'غير متوفر';
    final double rate = (service['rate'] ?? 0).toDouble();
    final String descriptionAr =
        service['description_ar'] ?? 'لا يوجد وصف متاح';
    final String descriptionEn =
        service['description_en'] ?? 'No description available';
    final String duration = service['duration'] ?? 'غير محددة';
    final List<String> tools =
        List<String>.from(service['details']?['tools'] ?? []);
    final int staff = service['details']?['staff'] ?? 0;
    final List<dynamic> reviews = service['reviews'] ?? [];
    final List<Map<String, dynamic>> approvedReviews = reviews
        .where((review) => review['status'] == 'معتمد')
        .map((review) => review as Map<String, dynamic>)
        .toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(screenWidth * 0.02),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: screenHeight * 0.35,

              width: double.infinity,
              fit: BoxFit.contain,
              placeholder: (context, url) =>
                  const Center(child: CustomDotsTriangleLoader()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: Row(
              children: [
                Text(
                  rate.toStringAsFixed(1),
                  style: GoogleFonts.tajawal(
                    textStyle: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.star, color: Colors.yellow, size: 16),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getLocalizedText(context, nameAr, nameEn),
                  style: GoogleFonts.tajawal(
                    textStyle: TextStyle(
                      fontSize: screenWidth * 0.06,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "$price دينار",
                  style: GoogleFonts.tajawal(
                    textStyle: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  getLocalizedText(context, descriptionAr, descriptionEn),
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.tajawal(
                    textStyle: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  getLocalizedText(
                      context, "تفاصيل الخدمة:", "Service Details:"),
                  style: GoogleFonts.tajawal(
                    textStyle: TextStyle(
                      fontSize: screenWidth * 0.06,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: tools.isNotEmpty
                      ? tools.map((tool) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.check,
                                  color: Colors.green, size: 18),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  tool,
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
                        }).toList()
                      : [
                          Text(
                            getLocalizedText(context, "لا توجد أدوات متاحة.",
                                "No tools available."),
                            style: GoogleFonts.tajawal(
                              textStyle: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                ),
                const SizedBox(height: 10),
                Text(
                  "${getLocalizedText(context, "مدة الخدمة:", "Service Duration:")} $duration دقيقة",
                  style: GoogleFonts.tajawal(
                    textStyle: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getLocalizedText(
                          context, "آراء العملاء :", "Customer Reviews :"),
                      style: GoogleFonts.notoNaskhArabic(
                        textStyle: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: AppTheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push('/RateList');
                      },
                      child: Text(
                        getLocalizedText(context, "عرض المزيد", "Show More"),
                        style: GoogleFonts.notoNaskhArabic(
                          textStyle: TextStyle(
                            fontSize: screenWidth * 0.05,
                            color: AppTheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                approvedReviews.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: approvedReviews.length,
                        itemBuilder: (context, index) {
                          final review = approvedReviews[index];
                          return RateService(
                            name: review['user']?['name'] ?? 'مستخدم مجهول',
                            rating: review['rating'] ?? 0,
                            comment: review['comment'] ?? 'لا يوجد تعليق',
                            userImage: review['user']?['image_url'] ??
                                'https://api.alkashkhaa.com/public/default-user.png',
                            reviewDate: review['created_at'] ?? 'غير متوفر',
                          );
                        },
                      )
                    : Text(
                        getLocalizedText(context, "لا توجد مراجعات حتى الآن.",
                            "No reviews yet."),
                        style: GoogleFonts.tajawal(
                          textStyle: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
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
