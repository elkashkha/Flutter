import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkashkha/core/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../core/widgets/custom_button.dart';
import '../../../../profile_screen/presentation/view/widgets/about_us/view_model/teams_model.dart';

class SpecialistDetailsPage extends StatelessWidget {
  final Specialist specialist;

  const SpecialistDetailsPage({super.key, required this.specialist});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(specialist.name),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== صورة البروفايل =====
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: specialist.profilePicture,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CustomDotsTriangleLoader()),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.person,
                    size: 60,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ===== الاسم + المستوى + التقييم =====
            Center(
              child: Column(
                children: [
                  Text(
                    specialist.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  // const SizedBox(height: 6),
                  // Text(
                  //   specialist.level,
                  //   style: const TextStyle(fontSize: 14, color: Colors.black54),
                  // ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.rating, // كلمة "التقييم" من ملف الترجمة
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      buildStars(
                          specialist.overallRating), // النجوم حسب التقييم
                    ],
                  ),

                  // Text(
                  //   "${l10n.sessions}${specialist.sessionsCount} ",
                  //   style: const TextStyle(color: Colors.black, fontSize: 14),
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ===== الإيميل =====
            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.all(12),
            //   decoration: BoxDecoration(
            //     color: const Color(0xFFF9F9F9),
            //     borderRadius: BorderRadius.circular(6),
            //   ),
            //   child: Text(
            //     specialist.email,
            //     style: const TextStyle(
            //         fontSize: 14, fontWeight: FontWeight.w600),
            //   ),
            // ),

            const SizedBox(height: 20),

            // ===== الخبرة =====
            // Row(
            //   children: [
            //     Text("${l10n.experience}: ",
            //         style: const TextStyle(
            //             fontWeight: FontWeight.bold, fontSize: 15)),
            //     Container(
            //       padding:
            //           const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            //       decoration: BoxDecoration(
            //         color: const Color(0xFFF9F9F9),
            //         borderRadius: BorderRadius.circular(6),
            //       ),
            //       child: Text("${specialist.experienceYears} ${l10n.years}"),
            //     ),
            //   ],
            // ),

            const SizedBox(height: 20),

            // ===== الخدمات =====
            Text(
              l10n.servicesTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            specialist.services.isEmpty
                ? Text(l10n.noServices)
                : Wrap(
                    spacing: 8,
                    children: specialist.services
                        .map((service) => Chip(
                              label: Text(service.nameAr),
                            ))
                        .toList(),
                  ),

            const SizedBox(height: 20),

            // ===== البورتفوليو =====
            // Text(
            //   l10n.projectsTitle,
            //   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 10),
            // specialist.portfolio.isEmpty
            //     ? Text(l10n.noProjects)
            //     : SizedBox(
            //         height: 150,
            //         child: ListView.separated(
            //           scrollDirection: Axis.horizontal,
            //           itemCount: specialist.portfolio.length,
            //           separatorBuilder: (_, __) => const SizedBox(width: 8),
            //           itemBuilder: (context, index) {
            //             final item = specialist.portfolio[index];
            //             return Column(
            //               children: [
            //                 ClipRRect(
            //                   borderRadius: BorderRadius.circular(12),
            //                   child: CachedNetworkImage(
            //                     imageUrl: item.beforeImage,
            //                     width: 120,
            //                     height: 70,
            //                     fit: BoxFit.cover,
            //                   ),
            //                 ),
            //                 const SizedBox(height: 6),
            //                 ClipRRect(
            //                   borderRadius: BorderRadius.circular(12),
            //                   child: CachedNetworkImage(
            //                     imageUrl: item.afterImage,
            //                     width: 120,
            //                     height: 70,
            //                     fit: BoxFit.cover,
            //                   ),
            //                 ),
            //               ],
            //             );
            //           },
            //         ),
            //       ),

            const SizedBox(height: 20),

            // ===== زر الحجز =====
            MyCustomButton(
              text: l10n.book_now,
              voidCallback: () {
                context.push(
                  '/BookingSpecialist',
                  extra: {
                    "id": specialist.id,
                    "level": specialist.level,
                    "overprice": specialist.overprice,
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildStars(double rating) {
  List<Widget> stars = [];

  int fullStars = rating.floor();
  bool hasHalfStar = (rating - fullStars) >= 0.5;

  for (int i = 0; i < fullStars; i++) {
    stars.add(const Icon(Icons.star, color: Colors.amber, size: 20));
  }

  if (hasHalfStar) {
    stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 20));
  }

  while (stars.length < 5) {
    stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 20));
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: stars,
  );
}
