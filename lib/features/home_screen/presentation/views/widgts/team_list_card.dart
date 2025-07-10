import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkashkha/core/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../core/widgets/loading.dart';
import '../../../../profile_screen/presentation/view/widgets/about_us/view_model/teams_model.dart';

class TeamMemberCard extends StatelessWidget {
  final TeamMember member;
  final double width;
  final double height;

  const TeamMemberCard({
    super.key,
    required this.member,
    this.width =200,
    this.height = 121,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          '/team-details',
          extra: member,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: width,
          height: height,
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: member.image,
                  width: width,
                  height: height,
                  fit: BoxFit.contain,
                  placeholder: (context, url) =>
                  const Center(child: CustomDotsTriangleLoader()),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error),
                ),
                Container(
                  width: width,
                  height: height,
                  color: Colors.black.withOpacity(0.5),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        member.nameAr ?? 'بدون اسم',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        member.descriptionAr ?? 'بدون وصف',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
