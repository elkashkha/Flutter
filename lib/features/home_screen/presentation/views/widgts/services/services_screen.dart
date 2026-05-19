import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../core/app_theme.dart';
import '../../../../../../core/widgets/custom_app_bar.dart';
import '../../../views_model/services/service_cubit.dart';
import '../../../views_model/services/service_state.dart';
import '../../../views_model/services/services_model.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

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

  static const String _defaultIcon = 'assets/service/scissor.svg';

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xff0B0B0F) : const Color(0xffFCFCFC),
        appBar: CustomAppBar(title: AppLocalizations.of(context)!.our_services),
        body: BlocBuilder<ServicesCubit, ServicesState>(
          builder: (context, state) {
            if (state is ServicesLoading) {
              return _ServicesShimmerGrid();
            } else if (state is ServicesError) {
              return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.red)),
              );
            } else if (state is ServicesLoaded) {
              final services = state.services;

              return GridView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 20),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 24,
                  childAspectRatio: 1.1,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  final iconPath =
                      _serviceIcons[service.id] ?? _defaultIcon;
                  final name =
                      isArabic ? service.nameAr : service.nameEn;

                  return _ServiceGridItem(
                    service: service,
                    iconPath: iconPath,
                    name: name,
                  );
                },
              );
            }
            return const Center(child: Text('لا توجد بيانات متاحة'));
          },
        ),
      ),
    );
  }
}

class _ServiceGridItem extends StatelessWidget {
  final Service service;
  final String iconPath;
  final String name;

  const _ServiceGridItem({
    required this.service,
    required this.iconPath,
    required this.name,
  });

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
              'imageUrl': service.imageUrl,
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
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                iconPath,
                width: 36,
                height: 36,
                colorFilter: ColorFilter.mode(
                  isDark ? Colors.white70 : const Color(0xFF2C2C2C),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Service name
          Text(
            _shorten(name, 2),
            textAlign: TextAlign.center,
            maxLines: 2,
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

class _ServicesShimmerGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 24,
        childAspectRatio: 1.1,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 60,
                height: 13,
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