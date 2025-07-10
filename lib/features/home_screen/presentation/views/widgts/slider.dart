import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:elkashkha/core/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/app_theme.dart';
import '../../../../../core/widgets/loading.dart';
import '../../views_model/slider/slider_cubit.dart';

class MyCarouselSlider extends StatelessWidget {
  const MyCarouselSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SliderCubit()..fetchSliders(),
      child: BlocBuilder<SliderCubit, SliderState>(
        builder: (context, state) {
          if (state is SliderLoading) {
            return const Center(child: CustomDotsTriangleLoader());
          } else if (state is SliderError) {
            return Center(child: Text(state.message));
          } else if (state is SliderLoaded) {
            return CarouselSlider(
              items: state.sliderModel.data?.map((slider) {
                    final locale = Localizations.localeOf(context).languageCode;
                    final isArabic = locale == 'ar';

                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: slider.image ?? 'assets/images/2.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            progressIndicatorBuilder: (context, url,
                                    downloadProgress) =>
                                const Center(child: CustomDotsTriangleLoader()),
                            errorWidget: (context, url, error) => const Center(
                                child: Icon(Icons.error,
                                    color: Colors.red, size: 50)),
                          ),
                        ),
                        Positioned(
                          right: isArabic ? 60 : null,
                          left: isArabic ? null : 60,
                          bottom: 12,
                          child: Container(
                            width: 230,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: isArabic
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  slider.title?[isArabic ? 'ar' : 'en'] ?? '',
                                  softWrap: true,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  slider.subtitle?[isArabic ? 'ar' : 'en'] ??
                                      '',
                                  softWrap: true,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    context.push('/ServicesScreen');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffD1D1D1),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: Text(
                                    isArabic
                                        ? 'اكتشف خدمتنا'
                                        : 'Explore Our Services',
                                    style: const TextStyle(
                                        color: AppTheme.primary, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList() ??
                  [],
              options: CarouselOptions(
                height: 190.0,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                aspectRatio: 16 / 7,
                viewportFraction: 0.85,
              ),
            );
          }
          return const Center(child: Text('لا توجد بيانات حالياً'));
        },
      ),
    );
  }
}
