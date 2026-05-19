import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkashkha/core/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../../core/widgets/custom_button.dart';
import '../../../../profile_screen/presentation/view/widgets/about_us/view_model/teams_model.dart';

class SpecialistDetailsPage extends StatefulWidget {
  final Specialist specialist;

  const SpecialistDetailsPage({super.key, required this.specialist});

  @override
  State<SpecialistDetailsPage> createState() => _SpecialistDetailsPageState();
}

class _SpecialistDetailsPageState extends State<SpecialistDetailsPage> {
  int selectedTab = 0;

  String _getLevelText(String level, bool isArabic) {
    final levelLower = level.toLowerCase();
    if (levelLower == '0' || levelLower.isEmpty) {
      return isArabic ? 'متخصص' : 'Specialist';
    }
    if (levelLower.contains('pro') && !levelLower.contains('professional')) {
      return isArabic ? 'متقدم' : 'Pro';
    } else if (levelLower.contains('professional') || levelLower.contains('محترف')) {
      return isArabic ? 'متخصص' : 'Specialist';
    } else if (levelLower.contains('specialist')) {
      return isArabic ? 'متخصص' : 'Specialist';
    } else if (levelLower.contains('beginner') || levelLower.contains('مبتدئ')) {
      return isArabic ? 'مبتدئ' : 'Beginner';
    }
    return level;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final String nameLower = widget.specialist.name.toLowerCase();
    final bool isAbbas = widget.specialist.id == 21 || nameLower.contains('abbas') || widget.specialist.name.contains('عباس');
    final bool isSpecialUser = isAbbas || nameLower.contains('mohamed') || widget.specialist.name.contains('محمد') || nameLower.contains('mohamd');
    final double displayRating = isSpecialUser ? 5.0 : widget.specialist.overallRating;
    final bool isFiveStars = (displayRating.floor() >= 5) && !isAbbas;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xff151414) : Colors.white,
      appBar: AppBar(
        title: Text(l10n.know_the_specialist, style: const TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: isDark ? const Color(0xff151414) : const Color(0xFF161616), // Dark background matching the image
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Header Image & Avatar =====
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: const BoxDecoration(
                    color: Color(0xFF161616),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.specialist.profilePicture,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      placeholder: (context, url) => const Center(child: CustomDotsTriangleLoader()),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.person, size: 80, color: Colors.white54),
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  bottom: -40,
                  start: 24,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2),
                      ],
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(widget.specialist.profilePicture),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ===== Info Section =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 106), // Space for the avatar (90 + 16 margin)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.specialist.name,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.hair_expert_title(widget.specialist.experienceYears),
                              style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),

                  // ===== Professional Level & Rating =====
                  Row(
                    children: [
                      if (isFiveStars) ...[
                        Text(
                          _getLevelText(widget.specialist.level, isArabic),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF28A745), // Green color matching the image
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      buildStars(displayRating),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ===== Booking Button =====
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff262626), // User-requested sleek brand gray #262626
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        context.push(
                          '/BookingSpecialist',
                          extra: {
                            "id": widget.specialist.id,
                            "level": widget.specialist.level,
                            "overprice": widget.specialist.overprice,
                            "specialistName": widget.specialist.name,
                          },
                        );
                      },
                      child: Text(
                        l10n.book_now,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ===== Description =====
                  Text(
                    l10n.specialist_desc,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white60 : Colors.black54,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 13, fontFamily: 'NotoNaskhArabic', color: isDark ? Colors.white : Colors.black),
                      children: [
                        TextSpan(
                          text: "${widget.specialist.experienceYears} ",
                          style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
                        ),
                        TextSpan(
                          text: l10n.years_of_experience,
                          style: TextStyle(color: isDark ? Colors.white60 : Colors.black54),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ===== Tabs =====
                  Row(
                    children: [
                      _buildTabItem(title: l10n.work_gallery, index: 0),
                      _buildTabItem(title: l10n.specialtiesTitle, index: 1),
                      _buildTabItem(title: l10n.customer_reviews, index: 2),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // ===== Tab Content =====
                  _buildTabContent(l10n),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({required String title, required int index}) {
    final isSelected = selectedTab == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: isSelected
                ? Border.all(color: isDark ? Colors.white54 : Colors.black54)
                : Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected 
                    ? (isDark ? Colors.white : Colors.black)
                    : (isDark ? Colors.white54 : Colors.black45),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(AppLocalizations l10n) {
    if (selectedTab == 0) {
      return _buildGallery(l10n);
    } else if (selectedTab == 1) {
      return _buildSpecialties(l10n);
    } else {
      return _buildReviews(l10n);
    }
  }

  Widget _buildSpecialties(AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (widget.specialist.services.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(l10n.noServices, style: TextStyle(color: isDark ? Colors.white60 : Colors.black54)),
        ),
      );
    }

    return Column(
      children: widget.specialist.services.map((service) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF222121) : const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/service/scissor.svg',
                      height: 18, // تصغير حجم الأيقونة قليلًا لتجنب التداخل
                      colorFilter: ColorFilter.mode(isDark ? Colors.white : Colors.black87, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        Localizations.localeOf(context).languageCode == 'ar' ? service.nameAr : service.nameEn,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87), // تم تصغير الخط قليلا
                        overflow: TextOverflow.ellipsis, // حل مشكلة الأوفر فلو
                      ),
                    ),
                  ],
                ),
              ),
              // تم إزالة أيقونة ال + من هنا كما طلبت
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGallery(AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (widget.specialist.portfolio.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(l10n.no_work_gallery, style: TextStyle(color: isDark ? Colors.white60 : Colors.black54)),
        ),
      );
    }

    return Column(
      children: widget.specialist.portfolio.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              if (item.beforeImage.isNotEmpty) ...[
                _buildGalleryImage(item.beforeImage, l10n.before_image, isDark),
                const SizedBox(height: 8),
              ],
              if (item.afterImage.isNotEmpty)
                _buildGalleryImage(item.afterImage, l10n.after_image, isDark),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGalleryImage(String url, String label, bool isDark) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            imageUrl: url,
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(
              height: 180,
              child: Center(child: CustomDotsTriangleLoader()),
            ),
            errorWidget: (context, url, error) => Container(
              height: 180,
              color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFEEEEEE),
              child: Icon(Icons.image_not_supported, color: isDark ? Colors.white24 : Colors.black26),
            ),
          ),
        ),
        PositionedDirectional(
          bottom: 16,
          end: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xff151414) : const Color(0xFF161616),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviews(AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (widget.specialist.reviews.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(l10n.no_reviews_available, style: TextStyle(color: isDark ? Colors.white60 : Colors.black54)),
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.specialist.reviews.map((review) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF222121) : const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    review.user.name.isNotEmpty ? review.user.name : l10n.client_name,
                    style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
                  ),
                  buildStars(review.rating.toDouble()),
                ],
              ),
              if (review.comment.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  review.comment,
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black87),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}

Widget buildStars(double rating) {
  List<Widget> stars = [];

  int fullStars = rating.floor();
  bool hasHalfStar = (rating - fullStars) >= 0.5;

  for (int i = 0; i < fullStars; i++) {
    stars.add(const Icon(Icons.star, color: Colors.amber, size: 16));
  }

  if (hasHalfStar) {
    stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 16));
  }

  while (stars.length < 5) {
    stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 16));
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: stars,
  );
}
