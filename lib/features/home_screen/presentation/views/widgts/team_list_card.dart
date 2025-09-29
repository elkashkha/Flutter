import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkashkha/core/app_router.dart';
import 'package:elkashkha/features/profile_screen/presentation/view/widgets/about_us/view_model/teams_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../core/widgets/loading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SpecialistCard extends StatelessWidget {
  final Specialist specialist;
  final double width;
  final double height;

  const SpecialistCard({
    super.key,
    required this.specialist,
    this.width = 200,
    this.height = 210,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        context.push(
          '/specialist-details',
          extra: specialist,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: specialist.profilePicture,
                      width: width,
                      height: height * 0.35,
                      fit: BoxFit.contain,
                      placeholder: (context, url) =>
                          const Center(child: CustomDotsTriangleLoader()),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.person,
                        size: 60,
                      ),
                    ),
                    // Positioned(
                    //   top: 8,
                    //   right: 8,
                    //   child: Container(
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 8, vertical: 4),
                    //     decoration: BoxDecoration(
                    //       color: Colors.black.withOpacity(0.5),
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //     child: Text(
                    //       specialist.level.isNotEmpty
                    //           ? specialist.level
                    //           : 'بدون مستوى',
                    //       style: const TextStyle(
                    //         color: Colors.white,
                    //         fontSize: 12,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                specialist.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.rating,
                    // كلمة "التقييم" من ملف الترجمة
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  buildStars(specialist.overallRating),
                  const SizedBox(width: 4),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildStars(double rating) {
  List<Widget> stars = [];

  int fullStars = rating.floor(); // عدد النجوم الكاملة
  bool hasHalfStar = (rating - fullStars) >= 0.5; // نص نجمة لو في كسور

  // أضيف النجوم الكاملة
  for (int i = 0; i < fullStars; i++) {
    stars.add(const Icon(Icons.star, color: Colors.amber, size: 18));
  }

  // أضيف نص نجمة لو موجود
  if (hasHalfStar) {
    stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 18));
  }

  // أكمل الباقي نجوم فاضية لحد 5
  while (stars.length < 5) {
    stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 18));
  }

  return Row(mainAxisSize: MainAxisSize.min, children: stars);
}
