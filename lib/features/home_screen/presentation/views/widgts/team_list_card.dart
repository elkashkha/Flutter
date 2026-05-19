import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elkashkha/features/profile_screen/presentation/view/widgets/about_us/view_model/teams_model.dart';
import '../../../../../../../core/widgets/loading.dart';

class SpecialistCard extends StatelessWidget {
  final Specialist specialist;
  final double width;
  final double height;

  const SpecialistCard({
    super.key,
    required this.specialist,
    this.width = 160,
    this.height = 200,
  });

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
    } else if (levelLower.contains('intermediate') || levelLower.contains('متوسط')) {
      return isArabic ? 'متوسط' : 'Intermediate';
    } else if (levelLower.contains('5 star') || levelLower.contains('5 نجوم')) {
      return isArabic ? '5 نجوم' : '5 Stars';
    }
    return level;
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String rawRole = specialist.services.isNotEmpty
        ? (isArabic ? specialist.services.first.nameAr : specialist.services.first.nameEn)
        : (isArabic ? 'متخصص' : 'Specialist');
    final role = rawRole.split(' ').take(3).join(' ');
    
    final String nameLower = specialist.name.toLowerCase();
    final bool isAbbas = specialist.id == 21 || nameLower.contains('abbas') || specialist.name.contains('عباس');
    final bool isSpecialUser = isAbbas || nameLower.contains('mohamed') || specialist.name.contains('محمد') || nameLower.contains('mohamd');
    final double displayRating = isSpecialUser ? 5.0 : specialist.overallRating;
    final bool isFiveStars = (displayRating.floor() >= 5) && !isAbbas;

    return GestureDetector(
      onTap: () {
        context.push(
          '/specialist-details',
          extra: specialist,
        );
      },
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? const Color(0xFF2E2E2E) : Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    // Avatar and Stars Stack
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isArabic && isFiveStars) ...[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              displayRating.floor().clamp(1, 5),
                              (index) => const Padding(
                                padding: EdgeInsets.symmetric(vertical: 1),
                                child: Icon(Icons.star, color: Colors.amber, size: 13),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        
                        // Circular Image
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade100, width: 2),
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: specialist.profilePicture,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => const Center(child: CustomDotsTriangleLoader()),
                              errorWidget: (_, __, ___) => const Icon(Icons.person, size: 40, color: Colors.grey),
                            ),
                          ),
                        ),
                        
                        if (!isArabic && isFiveStars) ...[
                          const SizedBox(width: 8),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              displayRating.floor().clamp(1, 5),
                              (index) => const Padding(
                                padding: EdgeInsets.symmetric(vertical: 1),
                                child: Icon(Icons.star, color: Colors.amber, size: 13),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Name
                    Text(
                      specialist.name,
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Role
                    Text(
                      role,
                      style: GoogleFonts.tajawal(
                        fontSize: 12,
                        color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            // Footer with Level or Stars
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF2F2F2),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: !isFiveStars
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        displayRating.floor().clamp(1, 5),
                        (index) => const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1),
                          child: Icon(Icons.star, color: Colors.amber, size: 16),
                        ),
                      ),
                    )
                  : Text(
                      _getLevelText(specialist.level, isArabic),
                      style: GoogleFonts.tajawal(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
