import 'package:elkashkha/features/home_screen/presentation/views/widgts/services/services_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../views_model/services/service_cubit.dart';
import '../../../views_model/services/service_state.dart';
import '../../../views_model/services/services_model.dart';

class ListService extends StatelessWidget {
  const ListService({super.key});

  /// Maps service IDs to local SVG icon paths
  static const Map<int, String> _serviceIcons = {
    40: 'assets/service/scissor.svg',
    31: 'assets/service/trimmer.svg',
    33: 'assets/service/skin-care.svg',
    42: 'assets/service/skin-care.svg',
    38: 'assets/service/hair-color.svg',
    34: 'assets/service/hair-spray.svg',
    32: 'assets/service/blow-dryer.svg',
    39: 'assets/service/hair-spray.svg',
  };

  /// Fallback icon path
  static const String _defaultIcon = 'assets/service/scissor.svg';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      builder: (context, state) {
        if (state is ServicesLoading) {
          return const ShimmerGridServiceLoader();
        } else if (state is ServicesError) {
          return Center(
            child:
                Text(state.message, style: const TextStyle(color: Colors.red)),
          );
        } else if (state is ServicesLoaded) {
          final isArabic = Localizations.localeOf(context).languageCode == 'ar';
          final services = state.services;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length > 6 ? 6 : services.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 15,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final service = services[index];
              final iconPath = _serviceIcons[service.id] ?? _defaultIcon;
              final name = isArabic ? service.nameAr : service.nameEn;

              return _ServiceGridItem(
                service: service,
                iconPath: iconPath,
                name: name,
                imageUrl: service.imageUrl,
                isArabic: isArabic,
              );
            },
          );
        }
        return const Center(child: Text('لا توجد بيانات متاحة'));
      },
    );
  }
}

/// A single service item in the grid — icon in a circle + name below
class _ServiceGridItem extends StatelessWidget {
  final Service service;
  final String iconPath;
  final String name;
  final String imageUrl;
  final bool isArabic;

  const _ServiceGridItem({
    required this.service,
    required this.iconPath,
    required this.name,
    required this.imageUrl,
    required this.isArabic,
  });

  /// Shorten name to first N words
  String _shorten(String text, int wordLimit) {
    final words = text.split(' ');
    if (words.length > wordLimit) {
      return words.sublist(0, wordLimit).join(' ');
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        context.push(
          '/ServiceDetails',
          extra: {
            'service': {
              'id': service.id,
              'imageUrl': imageUrl,
              'name_ar': service.nameAr,
              'name_en': service.nameEn,
              'price': service.price,
              'rate': service.averageRating,
              'duration': service.duration,
              'description_ar': service.descriptionAr,
              'description_en': service.descriptionEn,
              'details': {
                'tools': service.details.tools,
                'staff': service.details.staff,
              },
              'reviews': service.reviews,
            },
          },
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon circle
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                iconPath,
                width: 34,
                height: 34,
                colorFilter: ColorFilter.mode(
                  isDark ? Colors.white70 : const Color(0xFF2C2C2C),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Service name
          Text(
            _shorten(name, 2),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.tajawal(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer loader that matches the new grid layout
class ShimmerGridServiceLoader extends StatelessWidget {
  const ShimmerGridServiceLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 60,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
